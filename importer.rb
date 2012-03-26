require 'active_record'
require 'sqlite3'
require 'yaml'
require 'settings'
require 'log'
require 'import'
require 'export'
require 'audio'
require 'encoding_log'
require 'fileutils'

class Importer

  attr_reader :appdir, :userdir, :exedir 
  
  def initialize(args)
    
    # setup paths
    @appdir = RUBYSCRIPT2EXE.appdir
    @userdir = RUBYSCRIPT2EXE.userdir
    @exedir = RUBYSCRIPT2EXE.exedir
    
    # setup the database
    ActiveRecord::Base.logger = Log.get_logger
    ActiveRecord::Base.configurations = YAML::load(IO.read('config/database.yml'))
    ActiveRecord::Base.establish_connection(Settings.get('db'))
    
    if !ActiveRecord::Base.connection.table_exists?('encoding_logs')
      ActiveRecord::Schema.define do
        create_table :encoding_logs do |table|
          table.column :job, :string
          table.column :media, :string
          table.column :from, :string
          table.column :to, :string
        end
        add_index :encoding_logs, [:job, :media, :from]
      end
    end
    
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
        
        Log.info("#{files.length} files read")
        
        files.each do |file|
          
          Log.info("Processing #{file}")
          generated_files = []
          media_processor = nil
          
          begin

            # media encoding and transfering to destination storage            
            properties['medias'].each do |media_item|
              media_item.each do |media_name, media_settings|
                
                case properties['media_type']
                when 'audio' then
                  media_processor = Audio.new(media_name, media_settings['type'], media_settings['bit_rate'], media_settings['extension'])
                else
                  raise NotImplementedError.new("This media type has not been implemented yet.")
                end
                
                mediaLog = EncodingLog.where(:job => title, :media => media_name, :from => file).first
                
                if mediaLog.nil?
                  dest_file = media_processor.generate(file)
                  generated_files.push(dest_file)
                  Export.send_file(dest_file, true)
                  EncodingLog.create(:job => title, :media => media_name, :from => file, :to => dest_file)
                  Log.info("Media generated: #{dest_file}")
                else
                  Log.info("Media skipped: #{mediaLog.to}")
                end 
                
              end
            end
            
            # insert metadata in the database
            media_processor.register_metadata(file) unless media_processor.nil?
            
          rescue Exception => e
            Log.error(e.message)
            generated_files.each do |filepath|
              FileUtils.remove filepath if File.exists? filepath
            end
          end
          
        end
      
      end
      
    end
    
  end

end