require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rubydariah::Storage do
#  before do
#    VCR.insert_cassette 'player', :record => :new_episodes
#  end
#
#  after do
#    VCR.eject_cassette
#  end

  before do
    @auth = Rubydariah::Storage.new("http://ipedariah1.lsdf.kit.edu:8080/StorageImplementation-1.0-SNAPSHOT", "foo", "bar")
  end

  it "should create a new object" do
    @auth.should be_kind_of Rubydariah::Storage
  end

  it "should post a file" do
    VCR.use_cassette 'post' do
      response = @auth.post(File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3'))
      response.code.should == 201

      pid = URI(response.headers[:location]).path.split('/').last
      response = @auth.delete(pid)
      response.code.should == 204
    end
  end

  it "should get a file" do
    VCR.use_cassette 'get' do
      response = @auth.post(File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3'))
      response.code.should == 201

      pid = URI(response.headers[:location]).path.split('/').last
      response = @auth.get(pid)
      response.code.should == 200

      response = @auth.delete(pid)
      response.code.should == 204
    end
  end


  it "should get a list of options in the headers" do
    VCR.use_cassette 'options' do
      response = @auth.options
      response.code.should == 200
      allow = response.headers[:allow]
      allow.should include "OPTIONS"
      allow.should include "GET"
      allow.should include "HEAD"
      allow.should include "POST"
      allow.should include "PUT"
      allow.should include "DELETE"
    end
  end

end
