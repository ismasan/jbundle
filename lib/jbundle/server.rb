module JBundle
  
  class Server
    
    def initialize(jfile = JBundle::JFILE)
      @jfile = jfile
    end
    
    # Configure JBundle on every request. 
    # Expensive but allows for reloading changes to JFile
    def call(env)
      JBundle.config_from_file(@jfile)
      bundle_name = env['PATH_INFO'].sub('/', '')
      if !bundle_name == ''
        raise 'You need to define a bundle name ie. /my_bundle.js'
      end
      [200, {'Content-Type' => 'application/x-javascript'}, [JBundle.build(bundle_name).src]]
    end

  end
  
end