require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe "JBundle::Server" do
  
  before do
    f = File.join(File.expand_path(File.dirname(__FILE__)), 'JFile')
    @server = JBundle::Server.new(f)
  end
  
  describe '#call' do
    before do      
      @response = @server.call({'PATH_INFO' => '/foo.js'})
    end
    
    it 'should be 200 OK' do
      @response[0].should == 200
    end
    
    it 'should be a javascript response' do
      @response[1]['Content-Type'].should == 'application/x-javascript'
    end
    
    it 'should return content for given bundle' do
      @response[2].should == [JBundle.build('foo.js').src]
    end
    
  end
  
end