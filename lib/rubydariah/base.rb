module Rubydariah
  module Storage
    class Base
      def initialize(username, password)
          @auth = {:username => username, :password => password}
      end
    end
  end
end
