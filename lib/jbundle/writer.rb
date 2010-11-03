module JBundle
  
  class Version

    def initialize(string)
      @major, @minor, @patch = string.split('.')
      raise "require (major.minor.patch) eg: 1.3.1" unless @major && @minor && @patch
    end

    def full
      [@major, @minor, @patch].join('.')
    end

    def major_minor 
      [@major, @minor].join('.')
    end

    def releaseable
      prerelease? ? [full] : [full, major_minor]
    end
    
    def to_s
      full
    end

    protected

    def prerelease?
      @patch =~ /-pre/
    end

  end
  
  class Writer
    
    def initialize(compiler, version, target_dir)
      @compiler, @version, @target_dir = compiler, Version.new(version), target_dir
    end
    
    def write
      @version.releaseable.each do |version_dir|
        write_file @compiler.src, ::File.join(@target_dir, version_dir), @compiler.name
        if @compiler.buildable?
          write_file @compiler.min, ::File.join(@target_dir, version_dir), @compiler.min_name
        end
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