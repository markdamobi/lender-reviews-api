require 'rails_helper'

describe ReviewsRetrieverService do 
  describe "#call" do 
    before do 
      allow_any_instance_of(described_class).to receive(:get_reviews)
      allow_any_instance_of(described_class).to receive(:parse_reviews)
    end

    it "calls methods to get and the parse reviews data" do 
      reviews_retriever = described_class.new(lender_url: "")
      expect(reviews_retriever).to receive(:get_reviews).ordered
      expect(reviews_retriever).to receive(:parse_reviews).ordered
      reviews_retriever.call
    end
  end

  describe "#response_data" do 
    let!(:reviews) { double }
    let!(:reviews_count) { double }
    let!(:timestamp) { DateTime.current }
    
    before do 
      allow(reviews).to receive(:size).and_return(reviews_count)
      allow_any_instance_of(described_class).to receive(:reviews).and_return(reviews)
      allow_any_instance_of(described_class).to receive(:timestamp).and_return(timestamp)
      allow_any_instance_of(described_class).to receive(:number_of_pages).and_return(31)
    end

    it "returns a hash of response data containing needed contents" do 
      expected_response = {
        data: {
          reviews_count: reviews_count, 
          reviews: reviews, 
          timestamp: timestamp, 
          number_of_pages: 31,
          lender_url: ""
        }
      }
      reviews_retriever = described_class.new(lender_url: "")
      expect(reviews_retriever.response_data).to eql expected_response
    end
  end
end