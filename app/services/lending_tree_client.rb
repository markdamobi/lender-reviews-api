class LendingTreeClient
  def initialize(lender_url:, page_limit: nil)
    @lender_url = lender_url
    #NOTE: if page_limit is not a positive integer, this assumes you want all reviews. 
    @page_limit = page_limit.to_i < 1 ? Float::INFINITY : page_limit.to_i
  end

  attr_reader :lender_url, :page_limit, :reviews_data, :number_of_pages

  def fetch 
    validate_url 
    @reviews_data = []
    pid = 1
    while pid <= page_limit
      page_reviews_data = fetch_page_reviews(pid: pid)
      break if page_reviews_data.size == 0 
      @reviews_data += page_reviews_data
      pid += 1
    end 
    @number_of_pages = pid - 1
    reviews_data
  end

  ## note: this enforces https url. Can be changed later if needed. 
  def validate_url
    uri = URI.parse(lender_url)
    if !uri.scheme == "https"
      raise Exceptions::BadRequestError.new("Something is wrong with url: #{lender_url}. needs to be https.")
    elsif uri.host != "www.lendingtree.com"
      raise Exceptions::BadRequestError.new("Something is wrong with url: #{lender_url}. Host must be www.lendingtree.com")
    end
    true
  end

  private
  def fetch_page_reviews(pid:)
    page_data = Nokogiri::HTML(fetch_page(pid: pid))
    page_data.css(".mainReviews")
  end

  def fetch_page(pid:)
    HTTParty.get(lender_url, { query: { pid: pid } }).parsed_response
  end
end