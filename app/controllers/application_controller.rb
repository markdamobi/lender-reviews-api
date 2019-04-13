class ApplicationController < ActionController::API
  rescue_from Exceptions::BaseError, :with => :handle_error

  def handle_error(error)
    render json: { error: error.to_h }, status: error.status
  end
end
