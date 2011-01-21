## JBundle

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
        src.gsub(/<VERSION>/, config.version)
      end
      
      target_dir 'dist'

    end
    
Then write them to the configured target directory

    JBundle.write!
    
JBundle.write! returns an array of paths of all files written.
    
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
    
    JBundle.config_from_file './JFile'
    JBundle.build('foo.js').src
    
Or

    JBundle.config_from_file './JFile'
    JBundle.build('foo.js').min
    
You can bundle licenses in bundles. Licenses will not be minified even though they end up being part of minified files

    bundle 'foo2.js' do
      license 'license.txt'
      file 'file3.js'
      file 'file4.js'
    end
    
All defined filters will run on the src for all these cases.

## Filters

You can filter both minified and un-minified source and license content with the filter method

    # Filters can be use for string substitution
    filter do |src, config|
      src.gsub(/<VERSION>/, config.version)
    end

You can declare filters that run on un-minified output only

    filter :src do |src, config|
      src.gsub(/<SRC_MODE>/, 'full source')
    end

... And minified output only

    filter :min do |src, config|
      src.gsub(/<SRC_MODE>/, 'minified source')
    end
    
All filters must return a copy of the source, so use src.gsub instead of src.gsub!

## Jfile

You can add configuration in a Jfile in the root of your project.

    version '1.0.1'

    src_dir './'

    bundle 'foo.js' do
      license 'license.txt'
      file 'file1.js'
      file 'file2.js'
    end

    file 'page.html'

    filter do |src, config|
      src.gsub! /<VERSION>/, config.version.to_s
    end

    target_dir 'dist'
    
Then you can bundle everything up with the command line tool

    $ jbundle
    
You can run arbitrary code after writing all versioned files by registering an after_write block in your JFile. The following example copies a .swf file from the src dir to all versioned directories

    after_write do |config|

      config.version.releaseable.each do |version|
        from = "#{config.src_dir}/foo.swf"
        to = "#{config.target_dir}/#{version}/foo.swf"
        puts "copying #{to}"
        FileUtils.cp(from, to)
      end

    end
    
config.version.releaseble returns an array with with all created versions (ie. ['1.6.1', '1.6'] or just ['1.6.1-pre'] for prereleases).

Files in subdirectories in the src directory will keep the local directory tree, so

    file 'foo/text.txt'
    
Ends up as ./dist/1.6/foo/text.txt and ./dist/1.6.1/foo/text.txt

You can also copy to a different file name in the target directory using hash notation

    file 'foo/text.txt' => 'bar.txt'
    
## Pre-releases

If you want a prerelease not to overwrite the previous point release, suffix it with "-pre", as in:

    version '1.0.1-pre'
    

## TODO

- DRY up stuff, better error handling for missing config
    