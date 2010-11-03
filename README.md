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
      
      target_dir 'dist'

    end
    
Then write them to the configured target directory

    JBundle.write!
    
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
    
Or you can build a single bundle/file dinamically (ie. for testing, or for serving and caching dinamically)

    JBundle.build('foo.js').src
    
Or

    JBundle.build('foo.js').min
    
You can bundle licenses in bundles. Licenses will not be minified even if though they end up as part of minified files

    bundle 'foo2.js' do
      license 'license.txt'
      file 'file3.js'
      file 'file4.js'
    end
    
All defined filters will run on the src for all these cases.

## JBundlefile

You can add configuration in a JBundlefile in the root of your project.

    version '1.0.1'

    src_dir './'

    bundle 'foo.js' do
      license 'license.txt'
      file 'file1.js'
      file 'file2.js'
    end

    file 'page.html'

    filter do |src, config|
      src.gsub! /<VERSION>/, config.version
    end

    target_dir 'dist'
    
Then you can bundle everything up with the command line tool

    $ jbundle
    
## Pre-releases

If you want a prerelease not to overwrite the previous point release, suffix it with "-pre", as in:

    version '1.0.1-pre'
    

## TODO

- DRY up stuff, better error handling for missing config
    