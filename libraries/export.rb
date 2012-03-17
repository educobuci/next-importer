class Export
  
  @@processor = nil
  
  def self.send_file(filepath, move = true)
    Export.new unless @@processor
    @@processor.send_file(filepath, move)
  end

  private
  def initialize
    
    type = Settings.get('media_destination.type')
    settings = Settings.get('media_destination')
    
    case type
    when 'disk'
      require 'disk_export'
      @@processor = DiskExport.new(settings)
    when 'ftp'
      require 'ftp_export'
      @@processor = FTPExport.new(settings)
    when 'scp'
      require 'scp_export'
      @@processor = SCPExport.new(settings)
    when 'sftp'
      require 'sftp_export'
      @@processor = SFTPExport.new(settings)
    when 'amazons3'
      require 'amazon_s3_export'
      @@processor = AmazonS3Export.new(settings)
    end
    
  end
  
end