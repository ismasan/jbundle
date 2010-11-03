
JBundle.config do
  
end


version 2
dist 'dist'

bundle :some_file do
  file 'file1'
  file 'file2
end

file 'file3'

filter do |src|
  src.gsub /<VERSION>/, version
end

dist/2/some_file.js
dist/2/some_file.min.js
dist/2/file3.js
dist/2/file3.min.js

