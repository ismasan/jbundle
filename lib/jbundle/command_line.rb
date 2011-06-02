require 'thor'
module JBundle
  
  class CommandLine < Thor
    
    include Thor::Actions
    
    default_task :bundle
    
    map "s" => :server
    map "-v" => :version

    desc "bundle", "Minify and bundle bundle declarations into dist directory"
    method_option :jfile, :default => JBundle::JFILE, :aliases => "-j"
    def bundle
      begin
        JBundle.config_from_file(options[:jfile])
        JBundle.write!
      rescue JBundle::NoJFileError => boom
        puts boom.message
      end
    end
    
    desc 'server', 'Start test rack server on port 5555'
    method_option :port, :default => "5555", :aliases => "-p"
    method_option :jfile, :default => JBundle::JFILE, :aliases => "-j"
    def server
      require 'rack'
      JBundle.config_from_file(options[:jfile])
      say "Starting test server on http://localhost:#{options[:port]}. Available bundles:", :yellow
      JBundle.config.bundles_and_files.each do |f|
        say "- /#{f.original_name}", :green
      end

      handler = Rack::Handler.default
      downward = false
      ['INT', 'TERM', 'QUIT'].each do |signal|
        trap(signal) do
          exit! if downward
          downward = true
          handler.shutdown if handler.respond_to?(:shutdown)
          Process.wait rescue nil
          say 'Shutting down test server', :yellow
          exit!
        end
      end
      handler.run JBundle::Server.new, {:Port => options[:port]}
    end
    
    desc 'version', 'Print installed JBundle version'
    def version
      say JBundle::VERSION, :green
    end
    
    def self.source_root
      ::File.dirname(__FILE__)
    end
    
    AFTER_INIT_MESSAGE = %(
Done. Try it!
    
    jbundle s
    open test/index.html
    
Then package your work

    jsbundle
    )
    
    desc 'init', 'Create example JFile and test stubs'
    method_option :tests, :default => 'qunit', :aliases => '-t'
    def init(name)
      @name = name
      @klass_name = name.sub('.js', '').split(/[^a-z0-9]/i).map{|w| w.capitalize}.join
      
      template('templates/jfile.tt', "JFile")
      empty_directory 'src'
      template('templates/license.tt', "src/license.txt")
      template('templates/lib.tt', "src/#{name}")
      if options[:tests] == 'qunit'
        empty_directory 'test'
        template('templates/index.tt', "test/index.html")
        template('templates/tests.tt', "test/tests.js")
        copy_file 'templates/qunit.tt', 'test/qunit.js'
        copy_file 'templates/qunit_css.tt', 'test/qunit.css'
      end
      empty_directory 'dist'
      say AFTER_INIT_MESSAGE, :yellow
    end
    
  end
end