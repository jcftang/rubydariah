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
      RestClient.proxy =  ENV['http_proxy']
      response = RestClient.get('http://dariah.de')
      puts response.code
    end
  end

  it "should create a new object" do
    @auth = Rubydariah::Storage.new("http://dariah.de", "foo", "bar")
    @auth.should be_kind_of Rubydariah::Storage
  end

  it "should get a file" do
    VCR.use_cassette 'bar' do
      @auth = Rubydariah::Storage.new("http://ipedariah1.lsdf.kit.edu:8080/StorageImplementation-1.0-SNAPSHOT", "foo", "bar")
      response = @auth.get("resource")
      response.code.should == 200
    end
  end

  it "should post a file" do
    VCR.use_cassette 'post' do
      @auth = Rubydariah::Storage.new("http://ipedariah1.lsdf.kit.edu:8080/StorageImplementation-1.0-SNAPSHOT", "foo", "bar")
      response = @auth.post(File.expand_path(File.dirname(__FILE__) + '/fixtures/samplefile.mp3'))
      response.code.should == 201

      pid = URI(response.headers[:location]).path.split('/').last
      response = @auth.delete(pid)
      response.code.should == 204
    end
  end


  it "should get a list of options in the headers" do
    VCR.use_cassette 'options' do
      @auth = Rubydariah::Storage.new("http://ipedariah1.lsdf.kit.edu:8080/StorageImplementation-1.0-SNAPSHOT", "foo", "bar")
      response = @auth.options
      response.code.should == 200
    end
  end

end
