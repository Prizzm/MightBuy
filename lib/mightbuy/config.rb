module Mightbuy
  class Config
    include Singleton
    def initialize
      configure_configatron
    end

    def email_sender
      configatron.email.sender
    end

    def facebook_appid
      configatron.facebook.appid
    end

    def facebook_token
      configatron.facebook.token
    end

    def twitter_appid
      configatron.twitter.appid
    end

    def twitter_token
      configatron.twitter.token
    end

    def method_missing(method, *args, &block)
      configatron.send(method, *args, &block)
    end

    private
    def configure_configatron
      yaml_data = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
      configatron.configure_from_hash(yaml_data)
    end
  end


  def self.load_config
    @@mightbuy_config = Mightbuy::Config.instance
  end

  def self.config
    @@mightbuy_config
  end
end

MB = Mightbuy
