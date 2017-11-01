require 'soft_rescue/version'

# SoftRescue.configure do |config|
#  config.logger = Logger.new
#  config.enabled = Rails.env.production?
#  config.capture_exception = -> exception { Raven.capture_exception(exception) }
# end
#
# SoftRescue.call(on_failure: 0, message: "Hi")

module SoftRescue
  module Config
    class << self
      attr_accessor :logger, :capture_exception, :enabled
    end
  end

  def self.configure
    yield Config
  end

  def self.call(on_failure: nil, message: nil)
    yield
  rescue StandardError => exception
    raise exception unless Config.enabled

    if Config.logger
      message = [message, exception.message].compact.join('. ')
      Config.logger.error(message)
    end

    Config.capture_exception.call(exception) if Config.capture_exception

    on_failure.is_a?(Proc) ? on_failure.call : on_failure
  end
end
