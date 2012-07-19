class RegistrationsController < Devise::RegistrationsController
  before_filter :logS
  def logS
    puts "session: ", session["devise.user_attributes"]
  end
  private
  
    def build_resource(hash=nil)
      hash ||= params[resource_name] || {}
      hash.merge! :visitor_code => visitor_code
      self.resource = resource_class.new_with_session(hash, session)
    end
  
end