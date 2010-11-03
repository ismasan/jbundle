require 'fileutils'
require 'jbundle/config'
require 'jbundle/file'
require 'jbundle/bundle'
require 'jbundle/builder'
require 'jbundle/writer'

module JBundle
  
  class << self
    
    attr_accessor :logger
    
    def log(msg)
      logger.call(msg)
    end
    
    def config(&block)
      @current_config ||= JBundle::Config.new
      @current_config.instance_eval(&block) if block_given?
      @current_config
    end
    
    def output
      @output ||= Builder.new(config).build!
    end
    
    def reset!
      @current_config = nil
      @output = nil
      self
    end
    
    def write!
      output.map do |compiler|
        Writer.new(compiler, config.version, config.target_dir || './dist').write
      end.flatten
    end
    
    def build(name)
      found = config.bundles_and_files.detect {|f| f.name == name}
      raise "No bundle or file found with name #{name}" unless found
      Builder.new(config).build_one found
    end
    
    def run(content)
      config.instance_eval content
      write!
    end
    
  end
  
  self.logger = lambda {|msg| puts "#{msg}\n"}
  
end
