class ReviewsController < ApplicationController
  def index 
    lender_url = params[:lender_url]
    page_limit = params[:page_limit].to_i
    reviews_retriever = ReviewsRetrieverService.new(lender_url: lender_url, page_limit: page_limit)

    reviews_retriever.call
    render json: reviews_retriever.response_data
  end
end
