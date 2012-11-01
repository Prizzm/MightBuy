begin
  require "ci/reporter/rake/rspec"

  namespace :mbci do
    desc "Setup mightbuy-ci server"
    task :setup do
      system("cp config/database.yml.example config/database.yml")
    end

    desc "Run tests on mightbuy-ci server"
    ENV['CI_REPORTS'] = 'reports/ci_reports'
    task :run => "ci:setup:rspec" do
      system("bundle exec rake spec")
      rspec_status = $?.to_i

      system("export HEADLESS=true && bundle exec rake cucumber")
      cucumber_status = $?.to_i

      exit(-1) if rspec_status != 0 || cucumber_status != 0
    end
  end
rescue LoadError
end
