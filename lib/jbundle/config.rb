module JBundle
  
  class Config
    
    attr_reader :bundles, :files, :filters, :after_write_blocks
    
    def initialize
      @bundles = []
      @files = []
      @filters = {:all => [], :min => [], :src => []}
      @after_write_blocks = []
      @version_options = {:directory => true}
    end
    
    def versioned_directories?
      @version_options[:directory]
    end
    
    def version(v = nil, opts = {})
      @version_options.merge! opts
      @version = JBundle::Version.new(v) if v
      @version
    end
    
    def src_dir(dir = nil)
      @src_dir = dir if dir
      @src_dir || './'
    end
    
    def target_dir(dir = nil)
      @target_dir = dir if dir
      @target_dir || './'
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
    
    def filter(mode = :all, &block)
      filters[mode.to_sym] << block
    end
    
    def after_write(&block)
      after_write_blocks << block
    end
    
    def bundles_and_files
      @bundles + @files
    end
    
  end
end