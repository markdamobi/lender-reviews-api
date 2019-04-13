class ApplicationController < ActionController::API
  rescue_from ActionController::RoutingError, with: :handle_routing_error
  rescue_from Exceptions::BaseError, with: :handle_error

  def handle_error(error)
    render json: { error: error.to_h }, status: error.status
  end

  def handle_routing_error(error)
    logger.error 'Routing error occurred'
    render json: { error: { message: error.message } }, status: 404 
  end

  def catch_routing_error
    raise ActionController::RoutingError.new("the endpoint #{params[:path]} is not available.")
  end
end
