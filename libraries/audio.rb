require 'file_info'

class Audio
  
  @parser = nil
 
  def initialize(name, type, bit_rate, extension)
    
    @name = name
    @type = type
    @bit_rate = bit_rate
    @extension = extension
    
    case type.downcase
    when 'aac_lc', 'aac_he', 'aac_hev2' 
      require 'nero_aac_audio'
      @parser = NeroAACAudio.new(type, bit_rate)
    else
      raise NotImplementedError.new("This encoding type has not been implemented yet.")
    end

  end
  
  def generate(file)
    basename = File.basename(file, File.extname(file)).gsub(/[\W]/, '')
    to = "#{Settings.get('media_destination.stage_path')}/#{basename}.#{@name}.#{@type}.#{@bit_rate}.#{SecureRandom.uuid.gsub('-', '')}.#{@extension}"
    Log.info("Creating media[#{@name}|#{@type}|#{@bit_rate}|#{@extension}]")
    @parser.generate(file, to)
    return to
  end
  
  def register_metadata(file)
    meta = FileInfo.get_info(file)
    Log.info(meta.inspect)    
  end
  
end