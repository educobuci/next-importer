require 'yaml'

module Settings
  # again - it's a singleton, thus implemented as a self-extended module
  extend self

  @_settings = {}
  attr_reader :_settings

  def get(name, default_value = nil)
    
    if (@_settings.empty?)
      load! File.expand_path(File.dirname(__FILE__)) + '/../config/main.yml'
    end
    
    cnf = @_settings
    name.split('.').each do |level|
      cnf = cnf[level]  
    end
     
    cnf || default_value
  end

  private
  def load!(filename)
    #YAML::ENGINE.yamler= 'syck'
    @_settings = YAML::load_file(filename)
  end

end