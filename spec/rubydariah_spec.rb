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
    @dariah.should be_valid
  end

  it "should save the file" do
    VCR.use_cassette 'save' do
      file_location = File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3')
      file_data = File.read(file_location)
      @dariah.payload = file_data
      @dariah.content_type = 'audio/mpeg'
      @dariah.save
      @dariah.id.should_not be_nil
    end
  end

  it "should update a file" do
    VCR.use_cassette 'update' do
      file_location = File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3')
      file_data = File.read(file_location)
      @dariah.payload = file_data
      @dariah.content_type = 'audio/mpeg'
      @dariah.save

      pid = @dariah.id
      md5 = Digest::MD5.hexdigest(@dariah.payload)
      file_location = File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile2.mp3')
      @dariah.payload = File.read(file_location)
      @dariah.content_type = 'audio/mpeg'
      @dariah.update

      update_pid = @dariah.id
      update_pid.should == pid

      update_md5 = Digest::MD5.hexdigest(@dariah.payload)
      update_md5.should_not == md5
    end
  end

  it "should get a file by id" do
    VCR.use_cassette 'get' do
      file_location = File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3')
      file_data = File.read(file_location)

      @dariah.payload = file_data
      @dariah.content_type = 'audio/mpeg'
      @dariah.save
      md5 = Digest::MD5.hexdigest(@dariah.payload)
      pid = @dariah.id

      @newdariah = Rubydariah::Storage.new("http://ipedariah1.lsdf.kit.edu:8080/StorageImplementation-1.0-SNAPSHOT", "foo", "bar")
      @newdariah.get_by_id(pid)
      @newdariah.content_type.should eq('audio/mpeg')

      get_md5 = Digest::MD5.hexdigest(@newdariah.payload)
      get_md5.should == md5

      #status = @dariah.delete(pid)
      #status.should == 204
    end
  end

  it "should get the header" do
    VCR.use_cassette 'head' do
      file_location = File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3')
      file_data = File.read(file_location)
      @dariah.payload = file_data
      @dariah.content_type = 'audio/mpeg'
      @dariah.save
      pid = @dariah.id

      @dariah.head(pid)
      @dariah.content_type.should eq('audio/mpeg')

      @dariah.delete_by_id(pid)
      @dariah.id
    end
  end

  it "should raise an error if an exception is caught" do
    VCR.use_cassette 'get_exception' do
      expect { @dariah.get_by_id('test') }.to raise_error(Rubydariah::DariahError)
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
      @dariah.payload = file_data
      @dariah.content_type = 'audio/mpeg'
      @dariah.save
      pid = @dariah.id

      @dariah.delete_by_id(pid)
    end
  end

end
