if defined?(Rails)
  require 'rails'
  module SparkPostMailer
    class Railtie < Rails::Railtie
      config.sparkpost_mailer = ActiveSupport::OrderedOptions.new
    end
  end
end
