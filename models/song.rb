require 'active_resource'

class Song < ActiveResource::Base
  self.site = Settings.get('media_kernel.base_url')
end