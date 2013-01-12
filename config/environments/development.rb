Dandelion::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

Rails.application.config.middleware.use OmniAuth::Builder do

  # require 'openid/store/filesystem'

  # # load certificates
  # require "openid/fetchers"
  # OpenID.fetcher.ca_file = "#{Rails.root}/config/ca-bundle.crt"
  
  provider :facebook, '399028323511585', '47e5d4a5cd54c04bac914f60fa4ada0c', {:scope => 'publish_stream,offline_access,email'}
  provider :twitter, 'Xz4B1t9D1muuM21CMunc3w', 'nSTUtyLy1VTM1n6TszvMOFMIX0DsrJDrgUw6XpNmM'
  provider :google_oauth2, '996062987170', 'aGTpudjzACdXgsJIQV5Dw-FF'
  
  # # dedicated openid
  # provider :openid, :store => OpenID::Store::Filesystem.new('/tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end

  
end
