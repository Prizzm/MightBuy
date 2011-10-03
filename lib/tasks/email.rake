namespace :email do
  
  desc "send test feedback invite"
  task :feedback => :environment do
    output = Notifications.feedback( Invites::Feedback.first ).deliver
    html   = output.to_s[/\<\!.+\<\/html\>/im]
    file = Rails.root.join("tmp/mailer.html")
    File.open(file, 'w') {|f| f.write(html) }
    `open #{file} -a Safari;`
  end
  
end