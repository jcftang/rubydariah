module Rubydariah
  class Storage
    include ActiveModel::Validations
    validates_presence_of :endpoint, :username, :password
    attr_accessor :endpoint, :username, :password, :id, :payload, :content_type

    def initialize(endpoint, username=nil, password=nil)
      @endpoint, @username, @password = endpoint, username, password

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

    def get_by_id(pid)
      handle_exception {
        @client[pid].get { |response, request, result, &block|
          case response.code
          when 200
            self.payload = response.body
            self.id = pid
            head(self.id)
          else
            response.return!(request, result, &block)
          end
        }
      }
    end

    def head(pid)
      handle_exception {
        @client[pid].head { |response, request, result, &block|
          case response.code
          when 200
            self.content_type = response.headers[:content_type]
          else
            response.return!(request, result, &block)
          end
        }
      }
    end

    def put(pid, payload, content_type)
      handle_exception {
        @client[pid].put(payload, :content_type => content_type) { |response, request, result, &block|
          case response.code
          when 201
            self.id = URI(response.headers[:location]).path.split('/').last
            return response.code, self.id unless self.id.empty?
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

    def delete_by_id(pid)
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
      @@instances.delete(self)
    end

    def save
      post unless self.payload.empty? and self.content.empty?
    end

    def update
      self.put(self.id, self.payload, self.content_type)
    end

    private
    def post
      handle_exception {
        @client.post(self.payload, :content_type => self.content_type) { |response, request, result, &block|
          case response.code
          when 201
            self.id = URI(response.headers[:location]).path.split('/').last
            return response.code, self.id unless self.id.empty?
          else
            response.return!(request, result, &block)
          end
        }
      }
    end

  end
end
