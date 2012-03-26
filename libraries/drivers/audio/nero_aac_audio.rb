require "file_info"

class NeroAACAudio

  def initialize(type, bit_rate)
    @type = type
    @bit_rate = bit_rate * 1000
  end

  def generate(from, to)
    
    info = FileInfo::get_info(from)
    
    if info.mime != 'audio/wav'
      to_tmp = Settings.get('media_destination.stage_path') + "/" + File.basename(to, File.extname(to)) + '.wav'
      decode(from, to_tmp)
      from = to_tmp 
    end
    
    encode(from, to)
    File.delete(to_tmp) unless to_tmp.nil?
    
  end
  
  private 
  def encode(from, to)
     Log.info("Encoding from #{from} to #{to}")
     res = system("neroaacenc -br #{@bit_rate} -if \"#{from.gsub('"', '\\"')}\" -of \"#{to.gsub("'", "\\'")}\"")
     raise Exception.new($0) if !res
  end

  def decode(from, to)
     Log.info("Decoding from #{from} to #{to}")
     res = system("neroaacdec -if \"#{from.gsub('"', '\\"')}\" -of \"#{to.gsub("'", "\\'")}\"")
     raise Exception.new($0) if !res
  end
  
end