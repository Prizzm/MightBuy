class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token, :only => [:create]
  
  layout "welcomes"
  
  def create
    @user = User.create(params[:user])
    @user.ensure_authentication_token!
    respond_to do |format|
      format.json do
         render :json => @user.to_json
      end
      format.html do
        redirect_to("/me?auth_token=#{@user.authentication_token}")
      end
    end
  end

  private
  def build_resource(hash=nil)
    hash ||= params[resource_name] || {}
    hash.merge! :visitor_code => visitor_code
    self.resource = resource_class.new_with_session(hash, session)
  end
end
