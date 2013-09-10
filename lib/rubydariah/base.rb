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
  end
end
