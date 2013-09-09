require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rubydariah::Storage do
#  before do
#    VCR.insert_cassette 'player', :record => :new_episodes
#  end
#
#  after do
#    VCR.eject_cassette
#  end

  it "should respond" do
    VCR.use_cassette 'foo' do
      response = HTTParty.get('http://dariah.de')
      puts response.code
    end
  end

  it "show create a new object" do
    @connection = Rubydariah::Storage::Base.new("foo", "bar")
  end
end
