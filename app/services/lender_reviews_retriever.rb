require 'benchmark'
class LenderReviewsRetriever
  def initialize(lender_url: , max_num_pages:)
    @lender_url = lender_url
    @max_num_pages = max_num_pages
    @timestamp = DateTime.current
  end

  attr_reader :lender_url, :reviews, :max_num_pages, :timestamp

  ######################## Some benchmarking ####################

  # Bench mark results. 
  # 50 pages.
  #                 user     system      total        real
  # get reviews     0.220314   0.056278   0.276592 ( 49.483117)
  # parse reviews   2.134610   0.019550   2.154160 (  2.175335)

  # 100 pages.
  #                 user     system      total        real
  # get reviews     0.461708   0.127361   0.589069 (103.979311)
  # parse reviews   4.219488   0.036743   4.256231 (  4.342068)

  # all reviews on the test url. 135 pages at the time of request.
  # get reviews    3.713324   0.291495   4.004819 (190.437787)
  # parse reviews  3.095351   0.066681   3.162032 (  3.749175)

  #################################################################

  def call
    Benchmark.bm do |bm|
      bm.report("get reviews"){ get_reviews }
      bm.report("parse reviews"){ parse_reviews }
    end
  end 

  def get_reviews
    @reviews_data = LendingTreeClient.new(lender_url: lender_url, max_num_pages: max_num_pages).fetch
  end

  def parse_reviews
    @reviews = reviews_data.map { |review_data| ReviewDataParser.new(data: review_data).extract_review }
  end 

  def response_data
    { 
      data: {
        num_reviews: reviews.size, 
        timestamp: timestamp, 
        reviews: reviews 
      } 
    }
  end

  private
  attr_reader :reviews_data
end