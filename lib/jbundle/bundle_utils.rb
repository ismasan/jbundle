module JBundle
  
  module BundleUtils
    
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