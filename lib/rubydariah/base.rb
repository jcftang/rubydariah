module Rubydariah
  class Storage
    attr_accessor :username, :password
    def initialize(username, password)
      @auth = {:username => username, :password => password}
    end
  end
end
