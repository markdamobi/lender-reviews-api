require 'rails_helper'

describe ReviewDataParser do 
  let!(:review_data) { Nokogiri::HTML(File.open(Rails.root.join("spec","test_data", "review.html"))) }
  describe "#extract review" do 
    it "takes in a nokogiri html representation of review and extracts the details." do 
      review = described_class.new(data: review_data).extract_review
      expect(review).to be_a Review
      expect(review.title).to eql "Great experience"
      expect(review.content).to eql "Working with Max Ortiz was a breath of fresh air."
      expect(review.author_name).to eql "Bruce"
      expect(review.author_city).to eql "BELLEVILLE"
      expect(review.author_state).to eql "IL"
      expect(review.date_of_review).to eql "April 2019"
    end
  end
end