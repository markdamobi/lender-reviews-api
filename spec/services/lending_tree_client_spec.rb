require 'rails_helper'

describe LendingTreeClient do 
  let!(:sample_html_data_with_reviews) { File.read(Rails.root.join("spec","test_data", "reviews.html")) }
  let!(:sample_html_data_without_reviews) { File.read(Rails.root.join("spec","test_data", "no_reviews.html")) }
  
  describe "#initialize" do 
    it "raises error if lender_url is blank" do 
      expect{ described_class.new }.to raise_error(Exceptions::BadRequestError)
    end
  end

  describe "#fetch" do
    before do 
      ## simulate a lender that has just 2 pages of reviews. 
      allow_any_instance_of(described_class).to receive(:fetch_page).with(pid: 1).and_return(sample_html_data_with_reviews)
      allow_any_instance_of(described_class).to receive(:fetch_page).with(pid: 2).and_return(sample_html_data_with_reviews)
      allow_any_instance_of(described_class).to receive(:fetch_page).with(pid: 3).and_return(sample_html_data_without_reviews)
    end

    it "fetches data starting from first page until there's no more reviews data." do
      client = described_class.new(lender_url: "https://www.lendingtree.com/reviews")
      client.fetch 
      expect(client.number_of_pages).to eql 2
      expect(client.reviews_data.size).to eql 20
      expect(client.reviews_data.first.attributes["class"].value).to include "mainReviews"
    end

    it "fetches the number of pages requested if optional page_limit was set" do 
      client = described_class.new(lender_url: "https://www.lendingtree.com/reviews", page_limit: 1)
      client.fetch 
      expect(client.number_of_pages).to eql 1
      expect(client.reviews_data.size).to eql 10
    end
  end

  describe "validate_url" do 
    context "when url is not https" do 
      it "raises error indicating a bad request." do 
        client = described_class.new(lender_url: "www.lendingtree.com")
        expect { client.validate_url }.to raise_error(Exceptions::BadRequestError)
      end
    end

    context "when url is https" do 
      context "when the host is not lendingtree.com" do
        it "raises error indicating a bad request." do 
          client = described_class.new(lender_url: "https://www.lendertree.com/reviews")
          expect { client.validate_url }.to raise_error(Exceptions::BadRequestError)
        end
      end

      context "when the lender_url doesn't start with https://www.lendertree.com/reviews" do 
        it "raises error indicating a bad request." do 
          client = described_class.new(lender_url: "https://www.lendingtree.com/someotherplace")
          expect { client.validate_url }.to raise_error(Exceptions::BadRequestError)
        end
      end

      context "when the host is lendingtree.com and lender url starts with https://www.lendertree.com/reviews" do 
        it "returns true" do 
          client = described_class.new(lender_url: "https://www.lendingtree.com/reviews")
          expect(client.validate_url).to be_truthy
        end
      end

    end
  end
end