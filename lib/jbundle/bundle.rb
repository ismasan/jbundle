module JBundle
  
  class Bundle
    
    include Enumerable
    
    attr_reader :name, :licenses

    def initialize(name)
      @name = name.to_s
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