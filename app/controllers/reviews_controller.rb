class ReviewsController < ApplicationController
  def index 
    lender_url = params[:lender_url]
    max_num_pages = params[:max_num_pages]
    reviews_retriever = LenderReviewsRetriever.new(lender_url: lender_url, max_num_pages: max_num_pages)

    reviews_retriever.call
    render json: reviews_retriever.response_data
  end
end
