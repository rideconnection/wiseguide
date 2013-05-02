Wiseguide::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Copied from production:

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are enabled and caching is turned on
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Needed for sending new users' confirmation email
  config.action_mailer.default_url_options = { :host => 'ridestage.panopticdev.com/wiseguide' }

end

# Turn off auto TLS for e-mail
ActionMailer::Base.smtp_settings[:enable_starttls_auto] = false
