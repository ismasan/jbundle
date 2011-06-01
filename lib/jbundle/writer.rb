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
    # Interpolation tokens
    TOKENS = {
      :version  => '[:version]'
    }
    
    def initialize(compiler, config, target_dir)
      @compiler, @config, @version, @target_dir = compiler, config, config.version, target_dir
      @out = []
    end
    
    def write
      release_targets do |versioned_target, version_string|
        if @compiler.buildable? # versionable JS file
          @out << write_file(
            @compiler.src, 
            versioned_target, 
            @compiler.dir, 
            interpolate(@compiler.name, TOKENS[:version] => version_string)
          )
          @out << write_file(
            @compiler.min, 
            versioned_target, 
            @compiler.dir, 
            interpolate(@compiler.min_name, TOKENS[:version] => version_string)
          )
        else # Other files (HTML, SWF, etc)
          @out << copy_file(
            @compiler.src_path, 
            versioned_target, 
            @compiler.dir, 
            interpolate(@compiler.name, TOKENS[:version] => version_string)
          )
        end
      end
      @out
    end
    
    protected
    
    def interpolate(string, tokens)
      tokens.each do |key, value|
        string = string.gsub(key, value)
      end
      string
    end
    
    def release_targets(&block)
      @version.releaseable.each do |version_string|
        versioned_target = @config.versioned_directories? ? ::File.join(@target_dir, version_string) : @target_dir
        yield versioned_target, version_string
      end
    end
    
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