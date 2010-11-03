module JBundle
  
  class Writer
    
    def initialize(compiler, version, target_dir)
      @compiler, @version, @target_dir = compiler, version, target_dir
    end
    
    def write
      @version.releaseable.each do |version_dir|
        write_file @compiler.src, ::File.join(@target_dir, version_dir), @compiler.name
        write_file @compiler.min, ::File.join(@target_dir, version_dir), @compiler.min_name
      end
    end
    
    protected
    
    def write_file(content, dir_name, file_name)
      FileUtils.mkdir_p dir_name
      ::File.open(::File.join(dir_name, file_name), 'w') do |f|
        f.write content
      end
    end
    
  end
  
end