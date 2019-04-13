require 'rails_helper'

describe LendingTreeClient do 
  let!(:sample_html_data_with_reviews) { File.read(Rails.root.join("spec","test_data", "reviews.html")) }
  let!(:sample_html_data_without_reviews) { File.read(Rails.root.join("spec","test_data", "no_reviews.html")) }

  describe "#fetch" do
    before do 
      ## simulate a lender that has just 2 pages of reviews. 
      allow_any_instance_of(described_class).to receive(:fetch_page).with(pid: 1).and_return(sample_html_data_with_reviews)
      allow_any_instance_of(described_class).to receive(:fetch_page).with(pid: 2).and_return(sample_html_data_with_reviews)
      allow_any_instance_of(described_class).to receive(:fetch_page).with(pid: 3).and_return(sample_html_data_without_reviews)
    end

    it "fetches data starting from first page until there's no more reviews data." do
      client = described_class.new(lender_url: "https://www.lendingtree.com")
      client.fetch 
      expect(client.number_of_pages).to eql 2
      expect(client.reviews_data.size).to eql 20
      expect(client.reviews_data.first.attributes["class"].value).to include "mainReviews"
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
          client = described_class.new(lender_url: "https://www.lendertree.com")
          expect { client.validate_url }.to raise_error(Exceptions::BadRequestError)
        end
      end

      context "when the host is lendingtree.com" do 
        it "returns true" do 
          client = described_class.new(lender_url: "https://www.lendingtree.com")
          expect(client.validate_url).to be_truthy
        end
      end
    end
  end
end