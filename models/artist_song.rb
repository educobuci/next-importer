require 'active_resource'

class ArtistSong < ActiveResource::Base
  self.site = Settings.get('media_kernel.base_url')  
end