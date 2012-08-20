module OAuthSpecHelper
  def auth_hash
    info = OmniAuth::AuthHash::InfoHash.new

    info.first_name = "fname"
    info.image = "http://graph.facebook.com/123456/picture?type=square"
    info.last_name = "lname"
    info.location = "location, state, country"
    info.name = "fname lname"
    info.email = "hemant@example.com"
    info.nickname = "fname.lname"
    info.verified = true

    credentials = Hashie::Mash.new(
      token: 'secure_token',
      secret: 'hello_world',
      expires_at: 1321747205,
      expires: true
    )

    auth_hash = OmniAuth::AuthHash.new
    auth_hash.provider = "facebook"
    auth_hash.uid = "123456"
    auth_hash.info = info
    auth_hash.credentials = credentials
    auth_hash
  end
end
