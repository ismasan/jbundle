require 'fileutils'
require 'jbundle/config'
require 'jbundle/bundle_utils'
require 'jbundle/file'
require 'jbundle/bundle'
require 'jbundle/builder'
require 'jbundle/writer'
require 'jbundle/server'
require 'jbundle/version'

module JBundle
  
  JFILE = 'Jfile'
  
  class NoJFileError < StandardError;end
  class NoBundleError < StandardError;end
  
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
      _dist = config.target_dir || './dist'
      clear_current_dist_dir(_dist)
      out = output.map do |compiler|
        Writer.new(compiler, config, _dist).write
      end.flatten
      run_after_write unless config.after_write_blocks.empty?
      out
    end
    
    def build(name)
      found = config.bundles_and_files.detect {|f| f.original_name == name}
      raise NoBundleError, "No bundle or file found with name #{name}" unless found
      Builder.new(config).build_one found
    end
    
    def config_from_file(file)
      raise NoJFileError, "You need to define #{file}" unless ::File.exists?(file)
      reset!
      config.instance_eval( ::File.read(file), file )
    end
    
    def run_after_write
      config.after_write_blocks.each {|block| block.call(config)}
    end
    
    def clear_current_dist_dir(dist_dir)
      config.version.releaseable.each do |version_dir|
        FileUtils.rm_rf ::File.join(dist_dir, version_dir)
      end
    end
    
  end
  
  self.logger = lambda {|msg| puts "#{msg}\n"}
  
end

require 'jbundle/command_line'
