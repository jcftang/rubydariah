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


    # Post
    def post(file)
      RestClient.proxy = @auth[:proxy]
      puts "endpoint is #{@auth[:endpoint]} and file is #{file}"
      response = RestClient.post(@auth[:endpoint], :'Content-Type' => "audio/mp3", :data => File.read(file) )
      if response.code == 201
        puts "success"
      else
        puts "something went wrong"
      end
    end


    # Options
    def options
      RestClient.proxy = ENV['http_proxy']
      response = RestClient::Request.execute(:method => :options, url: @auth[:endpoint], :payload => "*")
      if response.code == 200
        puts "success"
      else
        puts "something went wrong"
      end
      response
    end

  end
end
