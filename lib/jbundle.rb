require 'fileutils'
require 'jbundle/config'
require 'jbundle/file'
require 'jbundle/bundle'
require 'jbundle/builder'
require 'jbundle/writer'

module JBundle
  
  class << self
    
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
    
  end
  
end
