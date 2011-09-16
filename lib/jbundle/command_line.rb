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
      JBundle.config_from_file(options[:jfile])
      say "Starting test server on http://localhost:#{options[:port]}. Available bundles:", :yellow
      JBundle.config.bundles_and_files.each do |f|
        say "- /#{f.original_name} ==> /#{f.name}", :green
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

    jbundle
)
    
    desc 'init', 'Create example JFile and test stubs. Usage: jbundle init foo.js'
    method_option :tests, :default => 'qunit', :aliases => '-t'
    def init(name = nil)
      name = ask("Name of your library (ie. foo.js, awesome.js, etc.):") unless name
      @name = name
      @klass_name = name.sub('.js', '').split(/[^a-z0-9]/i).map{|w| w.capitalize}.join
      
      template('templates/jfile.tt', "JFile")
      empty_directory 'src'
      template('templates/license.tt', "src/license.txt")
      template('templates/lib.tt', "src/#{name}")
      case options[:tests]
      when 'qunit' then init_qunit
      when 'jasmine' then init_jasmine
      else puts "Don't know how to initalize tests for #{options[:tests].inspect}"
      end
      empty_directory 'dist'
      say AFTER_INIT_MESSAGE, :yellow
    end
    
    private
    
    def init_qunit
      empty_directory 'test'
      template 'templates/qunit/index.html.tt', 'test/index.html'
      template 'templates/qunit/tests.js.tt', 'test/tests.js'
      copy_file 'templates/qunit/qunit.js', 'test/qunit.js'
      copy_file 'templates/qunit/qunit.css', 'test/qunit.css'
    end
    
    def init_jasmine
      empty_directory 'test'
      template 'templates/jasmine/index.html.tt', 'test/index.html'
      template 'templates/jasmine/tests.js.tt', 'test/tests.js'
      [
        'spec_helper.js',
        'jasmine_favicon.png',
        'jasmine.js',
        'jasmine.css',
        'jasmine-html.js'
      ].each do |file|
        template "templates/jasmine/#{file}", "test/#{file}"
      end
    end
    
  end
end