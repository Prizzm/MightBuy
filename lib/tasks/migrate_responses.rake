desc "Creates votes and comments from responses"
task :migrate_responses => :environment do
  Response.create_votes!
  Response.create_comments!
end
