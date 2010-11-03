module JBundle
  
  class Bundle
    
    include Enumerable
    
    attr_reader :name

    def initialize(name)
      @name = name.to_s
      @files = []
    end
    
    def file(f)
      @files << f
    end
    
    def each(&block)
      @files.each &block
    end
    
  end
  
end