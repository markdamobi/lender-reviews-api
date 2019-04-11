require 'Nokogiri'

## takes in html string representing page and then parses it. 
class ReviewDataParser
  def initialize(data:)
    @data = data
  end

  attr_reader :review

  ##TODO: refactor this method. looks a bit messy. 
  def extract_review
    title = data.css(".reviewTitle").inner_html
    content = data.css(".reviewText").inner_html
    author_name = data.css(".consumerName").inner_html.gsub(/\<span\>.*\<\/span\>/, "").strip
    star_rating = data.css(".recommended > .numRec").inner_html.match(/\((\d)\s*of\s*5\)/)[1]
    author_city, author_state = data.css(".consumerName > span").inner_html.gsub("from", "").strip.split(", ")
    date_of_review = data.css(".consumerReviewDate").inner_html.gsub("Reviewed in","").strip
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

  private
  attr_reader :data

end