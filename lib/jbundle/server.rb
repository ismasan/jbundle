require 'rack'
module JBundle
  
  class Server
    
    
    def initialize(jfile = JBundle::JFILE)
      @jfile = jfile
    end
    
    # Configure JBundle on every request. 
    # Expensive but allows for reloading changes to JFile
    def call(env)
      bundle_name = env['PATH_INFO'].sub('/', '')
      begin
        JBundle.config_from_file(@jfile)
        compiler = JBundle.build(bundle_name)
        body = compiler.buildable? ? compiler.src : compiler.raw_src
        [200, {'Content-Type' => ::Rack::Mime.mime_type(compiler.ext)}, [body]]
      rescue NoBundleError => boom
        p = bundle_name == '' ? '[bundle_name].js' : bundle_name
        [404, {'Content-Type' => 'text/plain'}, ["No bundle defined. Try defining /#{p} in your JFile"]]
      rescue NoJFileError => boom
        [404, {'Content-Type' => 'text/plain'}, [boom.message]]
      end
      
    end

  end
  
end