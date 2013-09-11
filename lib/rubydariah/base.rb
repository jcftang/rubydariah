module Rubydariah
  class Storage
    attr_accessor :endpoint, :username, :password


    # Initialise
    def initialize(endpoint, username=nil, password=nil)
      @endpoint = endpoint

      unless (username.nil? || password.nil?)
        @client = RestClient::Resource.new endpoint, username, password
      else
        @client = RestClient::Resource.new endpoint
      end

      RestClient.proxy = ENV['http_proxy']
    end


    # Get
    def get(file)
      response = @client[file].get
      if response.code == 200
        puts "success"
      else
        puts "something went wrong"
      end
      response
    end

    # Head
    def head(file)
      response = @client[file].head
      if response.code == 200
        puts "success"
      else
        puts "something went wrong"
      end
      response
    end

    # Post
    def post(file)
      response = @client.post File.new(file, 'rb')
      if response.code == 201
        puts "success"
      else
        puts "something went wrong"
      end
 
      response
    end


    # Options
    def options
      response = RestClient::Request.execute(:method => :options, url: @endpoint, :payload => "*")
      if response.code == 200
        puts "success"
      else
        puts "something went wrong"
      end
      response
    end

    # Delete
    def delete(pid)
      response = @client[pid].delete
      if response.code == 204
        puts "success"
      else
        puts "something went wrong"
      end
      response
    end

  end
end
