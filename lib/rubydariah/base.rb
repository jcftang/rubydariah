module Rubydariah
  module Storage
    class Base
      include HTTParty
      base_uri 'dariah.de'

      def initialize(username, password)
          @auth = {:username => username, :password => password}
      end
    end
  end
end
