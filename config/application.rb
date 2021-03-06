require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Canvasfactory
  class Application < Rails::Application

    config.time_zone = 'Seoul'
    # ASYNC 한 처리를 위해서 추가(메일)
    config.active_job.queue_adapter = :delayed_job

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    # CKEDITOR + CARRIERWAVE
    config.autoload_paths += %w(#{config.root}/app/models/ckeditor)
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
