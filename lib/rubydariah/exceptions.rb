module Rubydariah

  module StandardException
  end

  class DariahError < StandardError
    include StandardException

    attr_reader :code

    # +message+:: the error message to show the user
    def initialize(message, code=1)
      super(message)
      @message = message
      @code = code
    end

  end

end
