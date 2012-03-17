class FTPImport
  
  attr_accessor :path, :filter
  
  def initialize(setttings)
    @path = setttings['path']
    @filter = setttings['filter']
  end
  
  def get_files()
    raise NotImplementedError.new("This importer type has not been implemented yet.")
  end
  
end