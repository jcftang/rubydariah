# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "rubydariah"
  gem.homepage = "http://github.com/jcftang/rubydariah"
  gem.license = "MIT"
  gem.summary = %Q{A thin ruby wrapper to the Dariah API}
  gem.description = %Q{This gem provides low level access to the Dariah infrastructure}
  gem.email = "jtang@tchpc.tcd.ie, skenny@tchpc.tcd.ie, kcassidy@tchpc.tcd.ie"
  gem.authors = ["Jimmy Tang", "Stuart Kenny", "Kathryn Cassidy"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
require 'ci/reporter/rake/rspec'
RSpec::Core::RakeTask.new(:spec => ["ci:setup:rspec"]) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
