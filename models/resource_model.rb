require 'active_resource'

class ResourceModel < ActiveResource::Base
  self.site = Settings.get('media_kernel.base_url')
  
  def add_related(item)
    post(item.class.name.tableize.to_sym, :related_id => item.id)
  end
  
end