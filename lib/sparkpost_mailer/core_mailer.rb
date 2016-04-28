require 'active_support/all'

module SparkPostMailer
  class CoreMailer
      class InvalidEmail < StandardError; end
      class InvalidMailerMethod < StandardError; end
      class InvalidInterceptorParams < StandardError; end
      class InvalidMergeLanguageError < StandardError; end

    # Makes this class act as a singleton without it actually being a singleton
    # This keeps the syntax the same as the orginal mailers so we can swap quickly if something
    # goes wrong.
    def self.method_missing(method, *args)
      return super unless respond_to?(method)
      new.method(method).call(*args)
    end

    def self.respond_to?(method, include_private = false)
      super || instance_methods.include?(method.to_sym)
    end

    # Proxy route helpers to rails if Rails exists. Doing routes this way
    # makes it so this gem doesn't need to be a rails engine
    def method_missing(method, *args)
      return super unless defined?(Rails) && Rails.application.routes.url_helpers.respond_to?(method)
      # Check to see if one of the args is an open struct. If it is, we'll assume it's the
      # test stub and try to call a path or url attribute.
      if args.any? {|arg| arg.kind_of?(SparkPostMailer::Mock)}
        # take the first OpenStruct found in args and look for .url or.path
        args.each do |arg|
          if arg.kind_of?(SparkPostMailer::Mock)
            break arg.url || arg.path
          end
        end
      else
        options = args.extract_options!.merge({host: SparkPostMailer.config.default_url_options[:host], protocol: SparkPostMailer.config.default_url_options[:protocol]})
        args << options
        Rails.application.routes.url_helpers.method(method).call(*args)
      end
    end

    def image_path(image)
      if defined? Rails
        ActionController::Base.helpers.asset_path(image)
      else
        method_missing(:image_path, image)
      end
    end

    def image_url(image)
      "#{root_url}#{image_path(image).split('/').reject!(&:empty?).join('/')}"
    end

    def api_key
      SparkPostMailer.config.api_key
    end

    def sparkpost_client
      @sparkpost_client ||= SparkPost::Client.new(api_key)
    end
  end
end
