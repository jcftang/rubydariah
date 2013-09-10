module Rubydariah
  class Storage
    attr_accessor :username, :password
    include HTTParty
    base_uri 'dariah.de'

    def initialize(username, password)
      @auth = {:username => username, :password => password}
    end
  end
end
