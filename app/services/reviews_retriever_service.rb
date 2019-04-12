class ReviewsRetrieverService

  def initialize(lender_url: , page_limit: nil)
    @lender_url = lender_url
    @page_limit = page_limit
    @client = LendingTreeClient.new(lender_url: lender_url, page_limit: page_limit)
    @timestamp = DateTime.current
  end

  attr_reader :lender_url, :reviews, :page_limit, :timestamp
  delegate :reviews_data, :number_of_pages, to: :@client

  def call
    get_reviews
    parse_reviews
  end 

  def response_data
    { 
      data: {
        reviews_count: reviews.size, 
        reviews: reviews, 
        timestamp: timestamp, 
        number_of_pages: number_of_pages,
        lender_url: lender_url
      } 
    }
  end
  
  def get_reviews
    @client.fetch
  end
  
  def parse_reviews
    @reviews = reviews_data.map { |review_data| ReviewDataParser.new(data: review_data).extract_review }
  end 

  private :reviews_data, :get_reviews, :parse_reviews
end