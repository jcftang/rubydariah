require "httparty"
Dir[File.dirname(__FILE__) + '/rubydariah/*.rb'].each do |file|
  require file
end
