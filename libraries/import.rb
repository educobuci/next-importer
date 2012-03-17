class Import
  
  def self.get_files(type, settings)
    
    files = []
    
    case type.strip.downcase
    when 'disk'
      require 'disk_import'
      files = DiskImport.new(settings).get_files()
    when 'ftp'
      require 'ftp_import'
      files = FTPImport.new(settings).get_files()
    when 'scp'
      require 'scp_import'
      files = SCPImport.new(settings).get_files()
    when 'sftp'
      require 'sftp_import'
      files = SFTPImport.new(settings).get_files()
    when 'amazons3'
      require 'amazon_s3_import'
      files = AmazonS3Import.new(settings).get_files()
    end
    
    return files      
  
  end
  
end