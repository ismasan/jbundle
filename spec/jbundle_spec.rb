require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'fileutils'

describe "JBundle" do
  
  before do
    
    JBundle.reset!
    
    JBundle.config do
      version '1.6.1'
      
      src_dir File.dirname(__FILE__) + '/test_src'
      
      bundle 'foo.js' do
        file 'file1.js'
        file 'file2.js'
      end
      
      bundle 'foo2.js' do
        file 'file3.js'
        file 'file4.js'
      end
      
      file 'file4.js'
    end
    
  end
  
  it 'should have a version' do
    JBundle.config.version.to_s.should == '1.6.1'
  end
  
  it 'should have bundles' do
    JBundle.config.bundles[0].name.should == 'foo.js'
    JBundle.config.bundles[1].name.should == 'foo2.js'
  end
  
  context 'bundling' do
    
    it 'should bundle bundles' do
      JBundle.output.size.should == 3
      JBundle.output[0].name.should == 'foo.js'
      JBundle.output[0].src.should == "var a1 = 1;\nvar a2 = 2;\n"
      JBundle.output[0].min.should == "var a1=1,a2=2;\n"
    end
    
  end
  
  context 'writing' do
    
    before do
      @dist = File.dirname(__FILE__)+'/dist'
      FileUtils.rm_rf @dist
    end
    
    it 'should write files' do
      JBundle.write_to(@dist)
      
      File.exist?(@dist + '/1.6.1/foo.js').should be_true
      File.exist?(@dist + '/1.6.1/foo.min.js').should be_true
      File.exist?(@dist + '/1.6.1/foo2.js').should be_true
      File.exist?(@dist + '/1.6.1/foo2.min.js').should be_true
      File.exist?(@dist + '/1.6.1/file4.js').should be_true
      File.exist?(@dist + '/1.6.1/file4.min.js').should be_true
      
      File.exist?(@dist + '/1.6/foo.js').should be_true
      File.exist?(@dist + '/1.6/foo.min.js').should be_true
      File.exist?(@dist + '/1.6/foo2.js').should be_true
      File.exist?(@dist + '/1.6/foo2.min.js').should be_true
      File.exist?(@dist + '/1.6/file4.js').should be_true
      File.exist?(@dist + '/1.6/file4.min.js').should be_true
    end
  end
  
end
