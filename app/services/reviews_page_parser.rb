require 'Nokogiri'

## takes in html string representing page and then parses it. 
class ReviewsPageParser
  def initialize(page:)
    @page = Nokogiri::HTML(page)
  end

  attr_reader :page, :reviews

  def call
    extract_reviews
  end

  def extract_reviews
    @reviews = page.css(".mainReviews").map do |review_section|
      extract_details(review_section)
    end
  end

  ##TODO: refactor this method. looks a bit messy. 
  def extract_details(review_section)
    title = review_section.css(".reviewTitle").inner_html
    content = review_section.css(".reviewText").inner_html
    author_name = review_section.css(".consumerName").inner_html.gsub(/\<span\>.*\<\/span\>/, "").strip
    star_rating = review_section.css(".recommended > .numRec").inner_html.match(/\((\d)\s*of\s*5\)/)[1]
    author_city, author_state = review_section.css(".consumerName > span").inner_html.gsub("from", "").strip.split(", ")
    date_of_review = review_section.css(".consumerReviewDate").inner_html.gsub("Reviewed in","").strip
    Review.new(
      title: title, 
      content: content, 
      author_name: author_name, 
      star_rating: star_rating, 
      date_of_review: date_of_review, 
      author_city: author_city, 
      author_state: author_state
    )
  end
end