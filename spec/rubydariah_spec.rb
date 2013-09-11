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
      status, pid = @auth.post(File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3'), 'audio/mpeg')
      status.should == 201

      status = @auth.delete(pid)
      status.should == 204
    end
  end

  it "should get a file" do
    VCR.use_cassette 'get' do
      status, pid = @auth.post(File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3'), 'audio/mpeg')
      status.should == 201

      status, content_type = @auth.head(pid)
      status.should == 200
      content_type.should eq('audio/mpeg')

      status, data = @auth.get(pid)
      status.should == 200
      data.should be_true ## probably need a better check

      status = @auth.delete(pid)
      status.should == 204
    end
  end

  it "should get the header" do
    VCR.use_cassette 'head' do
      status, pid = @auth.post(File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3'), 'audio/mpeg')
      status.should == 201

      status, content_type = @auth.head(pid)
      status.should == 200
      content_type.should eq('audio/mpeg')

      status = @auth.delete(pid)
      status.should == 204
    end
  end

  it "should raise an error if an exception is caught" do
    VCR.use_cassette 'get_exception' do
      expect { @auth.get('test') }.to raise_error(Rubydariah::DariahError)
    end
  end
     
  it "should get a list of options in the headers" do
    VCR.use_cassette 'options' do
      status, allowed = @auth.options
      status.should == 200
      allowed.should include "OPTIONS"
      allowed.should include "GET"
      allowed.should include "HEAD"
      allowed.should include "POST"
      allowed.should include "PUT"
      allowed.should include "DELETE"
    end
  end

  it "should delete a file" do
    VCR.use_cassette 'delete' do
      status, pid = @auth.post(File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3'), 'audio/mpeg')
      status.should == 201

      status = @auth.delete(pid)
      status.should == 204
    end
  end

end
