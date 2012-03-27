require 'file_info'
require 'album'
require 'artist'
require 'audio_file'
require 'genre'
require 'image_file'
require 'song'

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
    save_metadata(file)
    return to
  end
  
  private
  def save_metadata(file)
    # get file metadata
    meta = FileInfo.get_info(file)
    meta.meta_data['genre'] = 'Rock nroll' #faking genre, later on I'll see how to bring the genre from the file metadata
    
    # register metadata in the database
    artist = save_artist(meta.meta_data['artist'])
    album = save_album(meta.meta_data['album'])
    genre = save_genre(meta.meta_data['genre'])
    song = save_song(artist, album, genre, meta.meta_data['title'], meta.meta_data['tracknum'])
    #media_id = save_media(song_id, meta.type, meta.size, meta.meta_data['length'], meta.meta_data['bitrate'])
    
    #return media_id
  end
  
  def save_artist(name)
    begin
      artist = Artist.find(:first, :params => {:name => name})
      if artist.nil?
        artist = Artist.new(:name => name)
        artist.save
        Log.info("New artist created: #{artist.id} - #{name}")
      end
      return artist
    rescue Exception => e
      Log.info("Error saving artist #{name}. Error: #{e.message}")
      raise e
    end
  end
  
  def save_album(title)
    begin
      album = Album.find(:first, :params => {:title => title})
      if album.nil?
        album = Album.new(:title => title)
        album.save
        Log.info("New album created: #{album.id} - #{title}")
      end
      return album
    rescue Exception => e
      Log.info("Error saving album #{title}. Error: #{e.message}")
      raise e
    end
  end

  def save_genre(title)
    begin
      genre = Genre.find(:first, :params => {:title => title})
      if genre.nil?
        genre = Genre.new(:title => title)
        genre.save
        Log.info("New genre created: #{genre.id} - #{title}")
      end
      return genre
    rescue Exception => e
      Log.info("Error saving genre #{genre}. Error: #{e.message}")
      raise e
    end
  end

  def save_song(artist, album, genre, title, order)
    begin
      song = Song.find(:first, :params => {:title => title, :album_id => album.id})
      if song.nil?
        song = Song.new(:title => title, :album_id => album.id, :genre_id => genre.id)
        song.save
        song.add_related(artist)
        Log.info("New song created: #{song.id} - #{title}")
      end
      return song
    rescue Exception => e
      Log.info("Error saving song #{title}. Error: #{e.message}")
      raise e
    end
  end

  def save_media(song_id, type, size, duration, bitrate)
  end
  
end