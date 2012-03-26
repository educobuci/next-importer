require 'active_resource'

class ArtistFileSong < ActiveResource::Base
  self.site = Settings.get('media_kernel.base_url')
end