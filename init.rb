require 'find'
require 'rubyscript2exe'

# include all sub-directories into the ruby's $LOAD_PATH variable
Find.find(File.expand_path(File.dirname(__FILE__))) do |d|
  $LOAD_PATH.unshift(d) if File.directory? d  
end

require 'importer'

if __FILE__ == $0
  
  importer = Importer.new(ARGV)
  importer.run

end