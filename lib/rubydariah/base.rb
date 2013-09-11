module Rubydariah
  class Storage
    attr_accessor :endpoint, :username, :password


    # Initialise
    def initialize(endpoint, username, password)
      @auth = {:endpoint => endpoint, :username => username, :password => password}
      RestClient.proxy = ENV['http_proxy']
    end


    # Get
    def get(file)
      begin
        response = RestClient.get("#{@auth[:endpoint]}/#{file}")
      rescue => e
        e.response
      end
      response
    end


    # Post
    def post(file)
      response = RestClient.post @auth[:endpoint], :data => File.new(file, 'rb')
      if response.code == 201
        puts "success"
      else
        puts "something went wrong"
      end
      response
    end


    # Options
    def options
      response = RestClient::Request.execute(:method => :options, url: @auth[:endpoint], :payload => "*")
      if response.code == 200
        puts "success"
      else
        puts "something went wrong"
      end
      response
    end

    # Delete
    def delete(pid)
      response = RestClient.delete("#{@auth[:endpoint]}/#{pid}")
      if response.code == 204
        puts "success"
      else
        puts "something went wrong"
      end
      response
    end

  end
end
