require 'active_resource'

class Genre < ActiveResource::Base
  self.site = Settings.get('media_kernel.base_url')
end