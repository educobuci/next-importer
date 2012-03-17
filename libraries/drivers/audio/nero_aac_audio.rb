require "file_info"

class NeroAACAudio

  def initialize(type, bit_rate)
    @type = type
    @bit_rate = bit_rate * 1000
  end

  def generate(from, to)
    p Next::Libs::FileInfo::get_info(from)
    #encode(from, to)
  end
  
  private
  def encode(from, to)
     res = system("neroaacenc -br #{@bit_rate} -if '#{from}' -of '#{to}'")
     raise Exception.new($0) if !res
  end

  def decode(from, to)
     res = system("neroaacdec -if '#{from}' -of '#{to}'")
     raise Exception.new($0) if !res
  end
  
end