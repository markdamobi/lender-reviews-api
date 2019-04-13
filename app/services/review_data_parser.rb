class ReviewDataParser 
  def initialize(data:)
    @data = data
  end

  def extract_review
    Review.new(
      title: title, 
      content: content, 
      star_rating: star_rating, 
      date_of_review: date_of_review, 
      author_name: author_info[:name], 
      author_city: author_info[:city], 
      author_state: author_info[:state]
    )
  end

  def title 
    data.css(".reviewTitle").inner_html.strip
  end

  def content
    data.css(".reviewText").inner_html.gsub("<br>", "\n").strip    
  end

  def author_name
    data.css(".consumerName").inner_html.gsub(/\<span\>.*\<\/span\>/, "").strip
  end

  def star_rating
    data.css(".recommended > .numRec").inner_html.match(/\((\d)\s*of\s*5\)/)[1]
  end

  def date_of_review
    data.css(".consumerReviewDate").inner_html.gsub("Reviewed in","").strip
  end

  def author_info 
    return @author_info if @author_info
    name, city, state = data.css(".consumerName")
      .inner_html.gsub(/\<span\>|\<\/span\>/, "")
      .split(/from|,/)
      .map(&:strip)
    @author_info = { name: name, city: city, state: state }
  end

  private
  attr_reader :data
end