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
  
  class Config
    
    attr_reader :bundles, :files, :src_dir
    
    def initialize
      @bundles = []
      @files = []
    end
    
    def version(v = nil)
      @version = Version.new(v) if v
      @version
    end
    
    def src_dir(dir = nil)
      @src_dir = dir if dir
      @src_dir
    end
    
    def bundle(name, &block)
      name = name.to_sym
      if !b = @bundles.detect{|a| a.name == name}
        b = Bundle.new(name)
        @bundles << b
      end
      b.instance_eval &block
      b
    end
    
    def file(f)
      @files << JBundle::File.new(f)
    end
    
    
    def bundles_and_files
      @bundles + @files
    end
    
  end
end