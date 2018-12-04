require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'sidekiq/testing'
Sidekiq::Testing.inline!
require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.app_host = "http://lvh.me"
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = true
  config.mock_with :rspec

  config.before do
    ActionMailer::Base.deliveries.clear
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with :truncation, except: %w(ar_internal_metadata)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.filter_gems_from_backtrace(
    "actionpack",
    "actionview",
    "activerecord",
    "activesupport",
    "capybara",
    "rack",
    "rack-test",
    "railties",
    "request_store",
    "warden",
    "zeus"
  )
  
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  config.include Warden::Test::Helpers, type: :feature
end
