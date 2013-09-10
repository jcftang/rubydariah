module Rubydariah
  class Storage
    attr_accessor :endpoint, :username, :password, :proxy


    # Initialise
    def initialize(endpoint, username, password, proxy = nil)
      @auth = {:endpoint => endpoint, :username => username, :password => password, :proxy => proxy}
    end


    # Get
    def get(file)
      RestClient.proxy = @auth[:proxy]
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
      puts response
      response
    end


  end
end
