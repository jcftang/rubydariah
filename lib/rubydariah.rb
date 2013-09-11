require "rest_client"
require "active_model"
Dir[File.dirname(__FILE__) + '/rubydariah/*.rb'].each do |file|
  require file
end
