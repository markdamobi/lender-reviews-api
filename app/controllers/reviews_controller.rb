class ReviewsController < ApplicationController
  def index 
    lender_url, page_limit = params[:lender_url], params[:page_limit]
    client = LendingTreeClient.new(lender_url: lender_url, page_limit: page_limit)
    reviews_retriever = ReviewsRetrieverService.new(client: client)
    reviews_retriever.call
    render json: reviews_retriever.response_data, status: 200
  end
end
