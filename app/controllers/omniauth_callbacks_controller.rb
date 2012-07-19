class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    if current_user then
      if request.env["omniauth.auth"].provider == "twitter" then
        u = current_user
        u.twitter_uid = request.env["omniauth.auth"].uid
        u.save
      elsif request.env["omniauth.auth"].provider == "facebook" then
        u = current_user
        u.facebook_uid = request.env["omniauth.auth"].uid
        u.save
      end
    else
      user = User.from_omniauth(request.env["omniauth.auth"])
      puts "returned user: ", user
      if user.persisted?
        flash.notice = "Signed in!"
        sign_in_and_redirect user
      else
        session["devise.user_attributes"] = user.attributes
        redirect_to new_user_registration_url
      end
    end
  end
  alias_method :twitter, :all
  alias_method :facebook, :all
end