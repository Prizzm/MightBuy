# require 'dragonfly/rails/images'

require 'dragonfly'
app = Dragonfly[:images]

app.configure_with(:imagemagick)
app.configure_with(:rails)

if Rails.env.production?
  app.configure do |c|
    c.datastore = Dragonfly::DataStorage::S3DataStore.new(
      :bucket_name => 'prizzm-invite-mightbuy',
      :access_key_id => ENV['AKIAJZIFEDWWPQFQMXFA'],
      :secret_access_key => ENV['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']
    )
  end
end

app.define_macro(ActiveRecord::Base, :image_accessor)