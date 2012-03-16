require 'yaml'

module Settings
  # again - it's a singleton, thus implemented as a self-extended module
  extend self

  @_settings = {}
  attr_reader :_settings

  # This is the main point of entry - we call Settings.load! and provide
  # a name of the file to read as it's argument. We can also pass in some
  # options, but at the moment it's being used to allow per-environment
  # overrides in Rails
  def load!(filename)
    YAML::ENGINE.yamler= 'syck'
    @_settings = YAML::load_file(filename)
  end

  def get(name, default_value = nil)
    
    if (@_settings.empty?)
      self.load! File.expand_path(File.dirname(__FILE__)) + '/../config/main.yml'
    end
    
    cnf = @_settings
    name.split('.').each do |level|
      cnf = cnf[level]  
    end
     
    cnf || default_value
  end

end