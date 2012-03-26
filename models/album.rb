require 'active_resource'

class Album < ActiveResource::Base
  self.site = Settings.get('media_kernel.base_url')
end