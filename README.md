## JBundle (in progress)

Define a set of javascript files to bundle and minify

    JBundle.config do
      version '1.6.1'

      src_dir File.dirname(__FILE__) + '/src'

      bundle 'foo.js' do
        file 'file1.js'
        file 'file2.js'
      end

      bundle 'foo2.js' do
        file 'file3.js'
        file 'file4.js'
      end

      file 'file4.js'

      file 'text.txt'
      
      # Filters can be use for string substitution
      filter do |src, config|
        src.gsub!(/<VERSION>/, config.version)
      end

    end
    
Then write them to a directory

    JBundle.write_to './dist'
    
This will write the following files:

    'dist/1.6.1/foo.js'
    'dist/1.6.1/foo.min.js'
    'dist/1.6.1/foo2.js'
    'dist/1.6.1/foo2.min.js'
    'dist/1.6.1/file4.js'
    'dist/1.6.1/file4.min.js'
    'dist/1.6.1/text.txt'
    
    'dist/1.6/foo.js'
    'dist/1.6/foo.min.js'
    'dist/1.6/foo2.js'
    'dist/1.6/foo2.min.js'
    'dist/1.6/file4.js'
    'dist/1.6/file4.min.js'
    'dist/1.6/text.txt'
    
Or you can build a single bundle/file dinamically (ie. for testing)

    JBundle.build('foo.js').src
    
Or

    JBundle.build('foo.js').min
    
All defined filters will run on the src for all these cases.
    