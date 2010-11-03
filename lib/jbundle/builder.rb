require 'closure-compiler'

module JBundle
  
  class Compiler
    
    BUILDABLE_FILES = ['.js']
    
    attr_reader :name, :src_dir
    
    def initialize(name, file_list, src_dir = 'src')
      @name, @file_list, @src_dir = name.to_s, file_list, src_dir
    end
    
    def buildable?
      BUILDABLE_FILES.include?(::File.extname(name))
    end
    
    def src
      @src ||= licenses + raw_src
    end
    
    def min
      @min ||= licenses + Closure::Compiler.new.compile(raw_src)
    end
    
    def min_name
      @min_name ||= (
        ext = ::File.extname(name)
        name.sub(ext, '') + '.min' + ext
      )
    end
    
    def licenses
      @licenses ||= if @file_list.respond_to?(:licenses)
        read_files @file_list.licenses
      else
        ''
      end
    end
    
    def raw_src
      @raw_src ||= read_files(@file_list)
    end
    
    protected
    
    def read_files(file_names)
      file_names.inject('') do |mem, file_name|
        mem << ::File.read(::File.join(src_dir, file_name))
        mem << "\n"
        mem
      end
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
    
    def build_one(f)
      compiler = Compiler.new(f.name, f, @config.src_dir)
      @config.filters.each do |filter|
        filter.call(compiler.licenses, @config)
        filter.call(compiler.raw_src, @config)
      end
      compiler
    end
    
  end
  
end