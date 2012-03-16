require 'logger'

module Log
  
  @@log = nil

  def self.info(msg)
    self.set_logger
    @@log.info(msg)
  end

  def self.warn(msg)
    self.set_logger
    @@log.warn(msg)
  end

  def self.debug(msg)
    self.set_logger
    @@log.debug(msg)
  end

  def self.error(msg)
    self.set_logger
    @@log.error(msg)
  end

  def self.fatal(msg)
    self.set_logger
    @@log.fatal(msg)
  end
  
  private 
  def self.set_logger
    if @@log.nil?
      logdev = Settings.get('log.logdev')
      logdev = STDOUT if logdev.strip.upcase == 'STDOUT'
      @@log = Logger.new(logdev, Settings.get('log.shift_age'), Settings.get('log.shift_size'))
      @@log.level = Logger.const_get Settings.get('log.level')
    end
  end
  
end