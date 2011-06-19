require 'closure-compiler'

module JBundle
  
  class Compiler
    
    BUILDABLE_FILES = ['.js']
    
    attr_reader :name, :src_dir, :dir
    
    def initialize(name, file_list, config)
      @config, @file_list, @src_dir = config, file_list, config.src_dir
      @name, @dir = parse_name(name)
    end
    
    def ext
      @ext ||= ::File.extname(name)
    end
    
    def buildable?
      BUILDABLE_FILES.include?(ext)
    end
    
    # This only makes sense for one-file objects
    def src_path
      ::File.join(@src_dir, @file_list.original_name)
    end
    
    def src
      @src ||= filter(filtered_licenses + filtered_src, :src)
    end
    
    def min
      @min ||= filter(filtered_licenses, :min) + Closure::Compiler.new.compile(filter(filtered_src, :min))
    end
    
    def filtered_licenses
      @filtered_licenses ||= filter(licenses, :all)
    end
    
    def filtered_src
      @filtered_src ||= filter(raw_src, :all)
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
    
    def parse_name(name)
      n = ::File.basename(name)
      d = ::File.dirname(name) if name =~ /\//
      [n,d]
    end
    
    def filter(content, mode)
      @config.filters[mode].each do |filter|
        content = filter.call(content, @config)
      end
      content
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
      Compiler.new(f.name, f, @config)
    end
    
  end
  
end