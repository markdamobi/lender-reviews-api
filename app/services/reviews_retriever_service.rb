class ReviewsRetrieverService

  def initialize(client: client)
    @page_limit = page_limit
    @client = client
    @timestamp = DateTime.current
  end

  attr_reader :reviews, :page_limit, :timestamp
  delegate :lender_url, :reviews_data, :number_of_pages, to: :@client

  def call
    get_reviews
    parse_reviews
  end 

  def response_data
    @response_data = { 
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