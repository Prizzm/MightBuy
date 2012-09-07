class RegistrationsController < Devise::RegistrationsController
  layout "welcomes"

  private
  def build_resource(hash=nil)
    hash ||= params[resource_name] || {}
    hash.merge! :visitor_code => visitor_code
    self.resource = resource_class.new_with_session(hash, session)
  end
end
