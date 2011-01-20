module JBundle
  
  class File
    
    include Enumerable
    
    attr_reader :name, :original_name
    
    def initialize(name)
      @original_name, @name = parse_name(name)
    end
    
    def each(&block)
      yield original_name
    end
    
    protected
    
    def parse_name(name)
      if name.is_a?(Hash)
        name.first
      else
        [name, name]
      end
    end
    
  end
  
end