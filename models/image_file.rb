require 'active_resource'

class ImageFile < ActiveResource::Base
  self.site = Settings.get('media_kernel.base_url')
end