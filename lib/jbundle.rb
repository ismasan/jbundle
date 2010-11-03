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
    
    def write_to(target_dir)
      output.each do |compiler|
        Writer.new(compiler, config.version, target_dir).write
      end
    end
    
    def build(name)
      found = config.bundles_and_files.detect {|f| f.name == name}
      raise "No bundle or file found with name #{name}" unless found
      Builder.new(config).build_one found
    end
    
    def run(content)
      config.instance_eval content
      write_to config.target_dir || './dist'
    end
    
  end
  
  self.logger = lambda {|msg| puts "#{msg}\n"}
  
end
