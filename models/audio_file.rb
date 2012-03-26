require 'active_resource'

class AudioFile < ActiveResource::Base
  self.site = Settings.get('media_kernel.base_url')
end