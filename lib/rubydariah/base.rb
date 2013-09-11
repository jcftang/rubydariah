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

    def handle_exception(&block)
      yield
    rescue => e
      if e.respond_to?(:response)
        raise DariahError.new(e.message, e.response.code)
      else
        raise DariahError.new(e.message, 1)
      end
    end

    # Get
    def get(file)
      handle_exception {
        @client[file].get { |response, request, result, &block|
          case response.code
          when 200
            payload = response.body
            return response.code, payload
          else
            response.return!(request, result, &block)
          end
        }
      }
    end

    # Head
    def head(file)
      handle_exception {
        @client[file].head { |response, request, result, &block|
          case response.code
          when 200
            content_type = response.headers[:content_type]
            return response.code, content_type
          else
            response.return!(request, result, &block)
          end
        }
      }
    end

    # Post
    def post(file, content_type)
      handle_exception {
        @client.post(File.new(file, 'rb'), :content_type => content_type) { |response, request, result, &block|
          case response.code
          when 201
            pid = URI(response.headers[:location]).path.split('/').last
            return response.code, pid
          else
            response.return!(request, result, &block)
          end
        }
      }
    end

    # Put
    def put(pid, file, content_type)
      handle_exception {
        @client[pid].put(File.new(file, 'rb'), :content_type => content_type) { |response, request, result, &block|
          case response.code
          when 201
            pid = URI(response.headers[:location]).path.split('/').last
            return response.code, pid
          else
            response.return!(request, result, &block)
          end
        }
      }
    end

    # Options
    def options
      handle_exception {
        RestClient::Request.execute(:method => :options, url: @endpoint, :payload => "*") { |response, request, result, &block|
          case response.code
          when 200
            return response.code, response.headers[:allow]
          else
            response.return!(request, result, &block)
          end
        }
      }
    end

    # Delete
    def delete(pid)
      handle_exception {
        @client[pid].delete { |response, request, result, &block|
          case response.code
          when 204
            return response.code
          else
            response.return!(request, result, &block)
          end
        }
      }
    end

  end
end
