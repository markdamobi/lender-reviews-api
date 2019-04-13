module Exceptions
  class BaseError < StandardError
    attr_reader :status, :status_message

    def initialize(msg="Something went wrong.", status=500, status_message="Server Error") 
      @status = status
      @status_message = status_message 
      super(msg)
    end 

    def to_h
      {message: message, status: status, status_message: status_message}
    end

  end
end