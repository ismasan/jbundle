require 'thor'
module JBundle
  
  class CommandLine < Thor
    default_task :bundle
    
    map "s" => :server
    map "-v" => :version

    desc "bundle", "Minify and bundle bundle declarations into dist directory"
    def bundle
      begin
        JBundle.config_from_file(JBundle::JFILE)
        JBundle.write!
      rescue JBundle::NoJFileError => boom
        puts boom.message
      end
    end
    
    desc 'server', 'Start test rack server on port 5555'
    method_option :port, :default => "5555", :aliases => "-p"
    def server
      require 'jbundle/server'
      require 'rack'
      puts "Starting test server on http://localhost:#{options[:port].inspect}/[:bundle_name].js"
      handler = Rack::Handler.default
      downward = false
      ['INT', 'TERM', 'QUIT'].each do |signal|
        trap(signal) do
          exit! if downward
          downward = true
          handler.shutdown if handler.respond_to?(:shutdown)
          Process.wait rescue nil
          puts 'Shutting down test server'
          exit!
        end
      end
      handler.run JBundle::Server.new, {:Port => options[:port]}
    end
    
    desc 'Print installed JBundle version'
    def version
      puts JBundle::VERSION
    end

  end
end