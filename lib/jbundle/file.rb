module JBundle
  
  class File
    
    include Enumerable
    
    attr_reader :name
    
    def initialize(name)
      @name = name.to_s
    end
    
    def each(&block)
      yield name
    end
    
  end
  
end