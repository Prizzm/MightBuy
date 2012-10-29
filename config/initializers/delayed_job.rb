Delayed::Worker.max_attempts = 5
Delayed::Worker.delay_jobs = Rails.env.production? && !ENV["RAILS_DONT_DELAY_JOBS"]
