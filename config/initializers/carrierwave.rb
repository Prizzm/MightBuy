CarrierWave.configure do |config|
  
  if Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
      :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY']
    }
    config.fog_directory  = 'prizzm-invites'
    config.cache_dir      = Rails.root.join("tmp/uploads")
  else
    config.storage :file
  end
  
end