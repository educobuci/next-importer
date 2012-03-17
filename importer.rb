require 'settings'
require 'log'
require 'import'
require 'export'
require 'audio'

class Importer

  attr_reader :appdir, :userdir, :exedir 
  
  def initialize(args)
    @appdir = RUBYSCRIPT2EXE.appdir
    @userdir = RUBYSCRIPT2EXE.userdir
    @exedir = RUBYSCRIPT2EXE.exedir
  end
  
  def run
    
    Settings.get('jobs').each do |job| 
      
      job.each do |title, properties| 
        
        Log.info("Processing #{title}:")
        
        files = []
        
        properties['from'].each do |from_entry|
          from_entry.each do |entry_type, entry_settings|
            files += Import.get_files(entry_type, entry_settings) 
          end
        end
        
        Log.info("#{files.length} read")
        
        files.each do |file|
          
          Log.info(" > Processing #{file}")
          
          properties['medias'].each do |media_item|
            
            media_item.each do |media_name, media_settings|
              
              case properties['media_type']
              when 'audio' then
                media_processor = Audio.new(media_name, media_settings['type'], media_settings['bit_rate'], media_settings['extension'])
              else
                raise NotImplementedError.new("This media type has not been implemented yet.")
              end
              
              dest_file = media_processor.generate(file)
              #Export.send_file(dest_file, false)
              
              Log.info(" >>> Media generated: #{dest_file}")
              
            end
            
          end
          
        end
      
      end
      
    end
    
  end

end