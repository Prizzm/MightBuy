namespace :email do
  
  desc "send test share email"
  task :share => :environment do
    user = User.first
    output = Notifications.share( Shares::Share.first ).deliver
    html   = output.to_s[/\<\!.+\<\/html\>/im]
    file = Rails.root.join("tmp/mailer.html")
    File.open(file, 'w') {|f| f.write(html) }
    `open #{file} -a Safari;`
  end
  
  desc "send test share email"
  task :responded => :environment do
    output = Notifications.responded( Response.first ).deliver
    html   = output.to_s[/\<\!.+\<\/html\>/im]
    file = Rails.root.join("tmp/mailer.html")
    File.open(file, 'w') {|f| f.write(html) }
    `open #{file} -a Safari;`
  end
  
end