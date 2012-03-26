require 'active_resource'

class Artist < ActiveResource::Base
  self.site = Settings.get('media_kernel.base_url')
end