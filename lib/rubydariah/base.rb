module Rubydariah
  class Storage
    attr_accessor :endpoint, :username, :password

    # Initialise
    #
    # == Parameters:
    # endpoint::
    #   The URI to the Dariah Storage API
    #
    # username::
    #   The username to use
    #
    # password::
    #   The username to use
    #
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

    # Getting a file
    #
    # == Parameters:
    # pid::
    #   The PID of the object to be retrieved
    #
    # == Returns
    # status::
    #   The status of the request
    #
    # payload::
    #   The binary data from the request
    #
    def get(pid)
      handle_exception {
        @client[pid].get { |response, request, result, &block|
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
    #
    # == Parameters:
    # pid::
    #   The PID of the object to inspect
    #
    # == Returns:
    # status::
    #   The status of the request
    #
    # content_type::
    #   The content/mime type
    #
    def head(pid)
      handle_exception {
        @client[pid].head { |response, request, result, &block|
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
    #
    # == Parameters:
    # payload::
    #   The payload of the object to post to the storage system
    #
    # content_type::
    #   The content/mime type
    #
    # == Returns:
    # status::
    #   The status of the request
    #
    # pid::
    #   The PID assigned to the object
    #
    def post(payload, content_type)
      handle_exception {
        @client.post(payload, :content_type => content_type) { |response, request, result, &block|
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
    #
    # Update a PID's data
    #
    # == Parameters:
    # payload::
    #   The payload of the object to put to the storage system
    #
    # content_type::
    #   The content/mime type
    #
    # == Returns:
    # status::
    #   The status of the request
    #
    # pid::
    #   The PID assigned to the object
    #
    def put(pid, payload, content_type)
      handle_exception {
        @client[pid].put(payload, :content_type => content_type) { |response, request, result, &block|
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
    #
    # Get a list of allowed methods
    #
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
    #
    # == Parameters:
    # pid::
    #   The PID of the object to delete
    #
    # == Returns:
    # status::
    #   The status of the request
    #
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
