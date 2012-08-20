class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    if current_user
      if request.env["omniauth.auth"].provider == "twitter"
        u = current_user
        u.twitter_uid = request.env["omniauth.auth"].uid
        u.twitter_oauth_token = request.env["omniauth.auth"]['credentials']['token']
        u.twitter_oauth_secret = request.env["omniauth.auth"]['credentials']['secret']
        u.save
      elsif request.env["omniauth.auth"].provider == "facebook"
        u = current_user
        u.image_url = request.env["omniauth.auth"].info.image
        u.facebook_uid = request.env["omniauth.auth"].uid
        u.facebook_oauth_token = request.env["omniauth.auth"]['credentials']['token']
        u.facebook_oauth_secret = request.env["omniauth.auth"]['credentials']['secret']
        u.save!
      end
      redirect_to '/me'
    else
      user = User.from_omniauth(request.env["omniauth.auth"])
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
