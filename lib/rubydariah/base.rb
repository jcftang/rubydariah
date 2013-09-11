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
    def post(file, content_type)
      @client.post(File.new(file, 'rb'), :content_type => content_type) { |response, request, result, &block|
      case response.code
      when 201
        pid = URI(response.headers[:location]).path.split('/').last
        return response.code, pid
      else
          response.return!(request, result, &block)
      end
      }
    end


    # Options
    def options
      RestClient::Request.execute(:method => :options, url: @endpoint, :payload => "*") { |response, request, result, &block|
        case response.code
        when 200
          return response.code, response.headers[:allow]
        else
          response.return!(request, result, &block)
        end
      }
    end

    # Delete
    def delete(pid)
      @client[pid].delete { |response, request, result, &block|
        case response.code
        when 204
          return response.code
        else
          response.return!(request, result, &block)
        end
      }
    end

  end
end
