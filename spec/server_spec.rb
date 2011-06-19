require File.expand_path(File.dirname(__FILE__) + '/spec_helper')


describe "JBundle::Server" do
  
  before do
    f = File.join(File.expand_path(File.dirname(__FILE__)), 'JFile')
    @server = JBundle::Server.new(f)
  end
  
  describe '#call' do
    
    describe 'with JavaScript bundle' do
      before do      
        @response = @server.call({'PATH_INFO' => '/foo.js'})
      end
      
      it 'should be 404 if no JFile found' do
        s = JBundle::Server.new("doesn-not-exist")
        r = s.call({'PATH_INFO' => '/foo.js'})
        r[0].should == 404
      end
      
      it 'should be 200 OK' do
        @response[0].should == 200
      end
      
      it 'should be a javascript response' do
        @response[1]['Content-Type'].should == 'application/javascript'
      end
      
      it 'should return content for given bundle' do
        @response[2].should == [JBundle.build('foo.js').src]
      end
      
      it 'should be 404 when no bundle found' do
        r = @server.call({'PATH_INFO' => '/nonexisting.js'})
        r[0].should == 404
      end
    end
    
    describe 'with non-JS file' do
      
      it 'should find and serve by original name' do
        response = @server.call({'PATH_INFO' => '/nested/foo.txt'})
        response[0].should == 200
        response[1]['Content-Type'].should == 'text/plain'
        response[2].should == ["This file is in a nested subdirectory\n"]
      end
      
      it 'should find and serve by distribution file name' do
        response = @server.call({'PATH_INFO' => '/flat_foo.txt'})
        response[0].should == 200
        response[1]['Content-Type'].should == 'text/plain'
        response[2].should == ["This file is in a nested subdirectory\n"]
      end
      
    end
  end
  
end