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
    
    def inspect
      "[JBundle::Version] #{full}"
    end

    protected

    def prerelease?
      @patch =~ /-pre/
    end

  end
  
  class Writer
    
    def initialize(compiler, version, target_dir)
      @compiler, @version, @target_dir = compiler, version, target_dir
      @out = []
    end
    
    def write
      @version.releaseable.each do |version_dir|
        versioned_target = ::File.join(@target_dir, version_dir)
        if @compiler.buildable?
          @out << write_file(@compiler.src, versioned_target, @compiler.dir, @compiler.name)
          @out << write_file(@compiler.min, versioned_target, @compiler.dir, @compiler.min_name)
        else
          @out << copy_file(@compiler.src_path, versioned_target, @compiler.dir, @compiler.name)
        end
      end
      @out
    end
    
    protected
    
    def copy_file(src, target, subdir, name)
      sub = ::File.join([target, subdir].compact)
      FileUtils.mkdir_p sub
      target = ::File.join(sub, name)
      JBundle.log("Copying to #{target}")
      FileUtils.cp src, target
      target
    end
    
    def write_file(content, dir_name, subdir, file_name)
      sub = ::File.join([dir_name, subdir].compact)
      FileUtils.mkdir_p sub
      target = ::File.join(sub, file_name)
      JBundle.log("Writing to #{target}")
      ::File.open(target, 'w') do |f|
        f.write content
      end
      target
    end
    
  end
  
end