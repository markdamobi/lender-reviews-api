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
      client = described_class.new(lender_url: "some_url")
      client.fetch 
      expect(client.number_of_pages).to eql 2
      expect(client.reviews_data.size).to eql 20
      expect(client.reviews_data.first.attributes["class"].value).to include "mainReviews"
    end
  end

end