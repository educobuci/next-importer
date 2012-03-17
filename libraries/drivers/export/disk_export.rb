require 'fileutils'

class DiskExport
  
  attr_accessor :destination
  
  def initialize(setttings)
    @destination = setttings['path']
  end
  
  def send_file(filepath, move)
    if move
      FileUtils.mv(filepath, @destination)
    else
      FileUtils.cp(filepath, @destination)
    end
  end
  
end