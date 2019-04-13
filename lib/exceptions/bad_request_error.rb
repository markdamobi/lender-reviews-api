module Exceptions
  class BadRequestError < Exceptions::BaseError
    def initialize(msg) 
      super(msg, 400, "Bad Request")
    end 
  end
end