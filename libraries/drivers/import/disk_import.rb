require "find"

class DiskImport
  
  attr_accessor :path, :filter
  
  def initialize(setttings)
    @path = setttings['path']
    @filter = setttings['filter']
  end
  
  def get_files()
    files = []
    Find.find(@path) do |f|
      files.push f if File.exists?(f) && (@filter.nil? || !f.match(@filter).nil?)
    end  
    return files
  end
  
end