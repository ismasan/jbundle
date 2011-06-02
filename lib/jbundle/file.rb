module JBundle
  
  class File
    
    include Enumerable
    include JBundle::BundleUtils
    
    attr_reader :name, :original_name
    
    def initialize(name)
      @original_name, @name = parse_name(name)
    end
    
    def each(&block)
      yield original_name
    end
    
  end
  
end