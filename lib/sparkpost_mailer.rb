require "sparkpost_mailer/version"
require 'action_view'
require 'sparkpost_mailer/railtie'
require 'sparkpost_mailer/mock'
require 'sparkpost_mailer/payload_mailer'

module SparkPostMailer
  autoload :SparkPost, 'sparkpost'

  if defined?(Rails)
    def self.configure(&block)
      if block_given?
        block.call(SparkPostMailer::Railtie.config.sparkpost_mailer)
      else
        SparkPostMailer::Railtie.config.sparkpost_mailer
      end
    end

    def self.config
      SparkPostMailer::Railtie.config.sparkpost_mailer
    end
  else
    def self.config
      @@config ||= OpenStruct.new(api_key: nil)
      @@config
    end
  end
end
