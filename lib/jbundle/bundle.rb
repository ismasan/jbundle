module JBundle
  
  class Bundle
    
    include Enumerable
    include JBundle::BundleUtils
    
    attr_reader :name, :original_name, :licenses

    def initialize(name)
      @original_name, @name = parse_name(name)
      @files = []
      @licenses = []
    end
    
    def file(f)
      @files << f
    end
    
    def license(license_file)
      @licenses << license_file
    end
    
    def each(&block)
      @files.each &block
    end
    
  end
  
end