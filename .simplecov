# -*- ruby -*-

require 'simplecov'
require 'simplecov-rcov'

SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.coverage_dir("reports") # change the directory to reports
SimpleCov.start 'rails' do
  add_filter "/vendor/"
end
