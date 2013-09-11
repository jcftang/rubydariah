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
    @dariah = Rubydariah::Storage.new("http://ipedariah1.lsdf.kit.edu:8080/StorageImplementation-1.0-SNAPSHOT", "foo", "bar")
  end

  it "should create a new object" do
    @dariah.should be_kind_of Rubydariah::Storage
  end

  it "should post a file" do
    VCR.use_cassette 'post' do
      file_location = File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3')
      file_data = File.read(file_location)
      status, pid = @dariah.post(file_data, 'audio/mpeg')
      status.should == 201

      status = @dariah.delete(pid)
      status.should == 204
    end
  end

  it "should put a file" do
    VCR.use_cassette 'put' do
      file_location = File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3')
      file_data = File.read(file_location)

      md5 = Digest::MD5.hexdigest(file_data)
      status, pid = @dariah.post(file_data, 'audio/mpeg')
      status.should == 201

      status, put_pid = @dariah.put(pid, file_data, 'audio/mpeg')
      put_pid.should == pid

      status, data = @dariah.get(put_pid)
      put_md5 = Digest::MD5.hexdigest(data)
      put_md5.should == md5
    end
  end

  it "should get a file" do
    VCR.use_cassette 'get' do
      file_location = File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3')
      file_data = File.read(file_location)
      md5 = Digest::MD5.hexdigest(file_data)
      status, pid = @dariah.post(file_data, 'audio/mpeg')
      status.should == 201

      status, content_type = @dariah.head(pid)
      status.should == 200
      content_type.should eq('audio/mpeg')

      status, data = @dariah.get(pid)
      status.should == 200
      get_md5 = Digest::MD5.hexdigest(data)
      get_md5.should == md5

      status = @dariah.delete(pid)
      status.should == 204
    end
  end

  it "should get the header" do
    VCR.use_cassette 'head' do
      file_location = File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3')
      file_data = File.read(file_location)
      status, pid = @dariah.post(file_data, 'audio/mpeg')
      status.should == 201

      status, content_type = @dariah.head(pid)
      status.should == 200
      content_type.should eq('audio/mpeg')

      status = @dariah.delete(pid)
      status.should == 204
    end
  end

  it "should raise an error if an exception is caught" do
    VCR.use_cassette 'get_exception' do
      expect { @dariah.get('test') }.to raise_error(Rubydariah::DariahError)
    end
  end

  it "should get a list of options in the headers" do
    VCR.use_cassette 'options' do
      status, allowed = @dariah.options
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
      file_location = File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3')
      file_data = File.read(file_location)
      status, pid = @dariah.post(file_data, 'audio/mpeg')
      status.should == 201

      status = @dariah.delete(pid)
      status.should == 204
    end
  end

end
