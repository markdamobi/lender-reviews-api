require 'HTTParty'
require 'Nokogiri'
require 'byebug'


class LendingTreeClient
  ##test url: https://www.lendingtree.com/reviews/personal/first-midwest-bank/52903183

  def initialize(lender_url:, max_num_pages: nil)
    @lender_url = lender_url
    @max_num_pages = max_num_pages
  end

  attr_reader :lender_url, :max_num_pages, :reviews_data

  def fetch_page_reviews(pid:)
    page_data = Nokogiri::HTML(fetch_page(pid: pid))
    page_data.css(".mainReviews")
  end

  def fetch_page(pid:)
    HTTParty.get(lender_url, { query: { pid: pid } }).parsed_response
  end

  def fetch 
    @reviews_data = []
    pid = 1

    while (max_num_pages < 1) || pid <= max_num_pages
      page_reviews_data = fetch_page_reviews(pid: pid)
      break if page_reviews_data.size == 0 
      @reviews_data += page_reviews_data
      pid += 1
    end 
    reviews_data
  end
end