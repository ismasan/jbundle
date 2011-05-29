module JBundle
  
  class Server

    def initialize
      JBundle.config_from_file(JBundle::JFILE)
    end

    def call(env)
      bundle_name = env['PATH_INFO'].sub('/', '')
      if !bundle_name == ''
        raise 'You need to define a bundle name ie. /my_bundle.js'
      end
      [200, {'Content-Type' => 'application/x-javascript'}, [JBundle.build(bundle_name).src]]
    end

  end
  
end