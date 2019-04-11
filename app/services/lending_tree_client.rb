require 'HTTParty'
require 'byebug'

class LendingTreeClient
  ##test url: https://www.lendingtree.com/reviews/personal/first-midwest-bank/52903183

  def initialize(lender_url:, max_num_pages: nil)
    @lender_url = lender_url
    @max_num_pages = max_num_pages
  end

  attr_reader :lender_url, :max_num_pages

  ## pid is the page id. 
  def fetch(pid: 1)
    HTTParty.get(lender_url, { query: { pid: pid } }).parsed_response
  end

  ## still need to decide what exactly to do with this. 
  def fetch_all 
    page_limit = max_num_pages.present? ? max_num_pages.to_i : 10

    @data = (1..page_limit).map do |pid|
      fetch(pid: pid)
    end
  end
end