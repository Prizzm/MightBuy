# require 'dragonfly/rails/images'

require 'dragonfly'
app = Dragonfly[:images]

app.configure_with(:imagemagick)
app.configure_with(:rails)

if Rails.env.production?
  app.configure do |c|
    c.datastore = Dragonfly::DataStorage::S3DataStore.new(
      :bucket_name => 'prizzm-invites',
      :access_key_id => ENV['AKIAJATKGAWCCDNFZN6Q'],
      :secret_access_key => ENV['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']
    )
  end
end

app.define_macro(ActiveRecord::Base, :image_accessor)