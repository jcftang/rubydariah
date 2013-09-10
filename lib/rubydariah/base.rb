module Rubydariah
  class Storage
    attr_accessor :endpoint, :username, :password


    # Initialise
    def initialize(endpoint, username, password)
      @auth = {:endpoint => endpoint, :username => username, :password => password}
    end


    # Get
    def get(file)
      RestClient.proxy = ENV['http_proxy']
      response = RestClient.get(@auth[:endpoint])
      if response.code == 200
        puts "success"
      else
        puts "something went wrong"
      end
      response
    end

    # Options
    def options
      RestClient.proxy = ENV['http_proxy']
      response = RestClient::Request.execute(:method => :options, url: @auth[:endpoint], :body => "*")
      if response.code == 200
        puts "success"
      else
        puts "something went wrong"
      end
      response
    end

  end
end
