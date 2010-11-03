require 'closure-compiler'

module JBundle
  
  class Compiler
    
    attr_reader :name
    attr_accessor :src
    
    def initialize(name, file_list, src_dir = 'src')
      @name, @file_list, @src_dir = name.to_s, file_list, src_dir
    end
    
    def compile!
      @src = @file_list.inject('') do |mem, file_name|
        mem << ::File.read(::File.join(@src_dir, file_name))
        mem << "\n"
        mem
      end
      self
    end
    
    def min
      @min ||= Closure::Compiler.new.compile(src)
    end
    
    def min_name
      @min_name ||= (
        ext = ::File.extname(name)
        name.sub(ext, '') + '.min' + ext
      )
    end
    
  end
  
  
  class Builder
    
    def initialize(config)
      @config = config
      @sources = []
    end
    
    def build!
      @sources = @config.bundles_and_files.map do |b|
        build_one b
      end
    end
    
    def build_one(compiler)
      comp = Compiler.new(compiler.name, compiler, @config.src_dir).compile!
      @config.filters.each do |filter|
        filter.call(comp.src, @config)
      end
      comp
    end
    
  end
  
end