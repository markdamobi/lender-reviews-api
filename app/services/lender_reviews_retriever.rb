class LenderReviewsRetriever
  def initialize(lender_url: , max_num_pages:)
    @lender_url = lender_url
    @max_num_pages = max_num_pages
    @timestamp = DateTime.current
  end

  attr_reader :lender_url, :reviews, :max_num_pages, :timestamp

  def call
    get_reviews
    parse_reviews
  end 

  def get_reviews
    @reviews_pages = LendingTreeClient.new(lender_url: lender_url, max_num_pages: max_num_pages ).fetch_all
  end

  def parse_reviews
    @reviews = ReviewsParser.new(pages: reviews_pages).call
  end 

  def response_data
     { data: {reviews: reviews, timestamp: timestamp} }
  end

  private
  attr_reader :reviews_pages
end