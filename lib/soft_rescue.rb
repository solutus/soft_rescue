require 'soft_rescue/version'

module SoftRescue
  # SoftRescue.configure do |config|
  #  config.logger = Logger.new
  #  config.enabled = Rails.env.production?
  #  config.capture_exception = -> exception { Raven.capture_exception(exception) }
  # end
  def self.configure
    yield Config
  end

  # SoftRescue.call(on_failure: 0, message: "my custom exception info")
  # SoftRescue.call(on_failure: -> { puts "fail!" }, message: "my custom exception info")
  def self.call(on_failure: nil, message: nil)
    yield
  rescue StandardError => exception
    ExceptionHandler.new(exception, on_failure, message).handle
  end

  # private logic
  module Config
    class << self
      attr_accessor :logger, :capture_exception, :enabled
    end
  end

  class ExceptionHandler
    def initialize(exception, on_failure, message)
      @exception = exception
      @on_failure = on_failure
      @message = message
    end

    def handle
      raise @exception unless Config.enabled
      handle_exception
    end

    private

    def handle_exception
      log
      capture_exception
      handle_failure
    end

    def log
      return unless Config.logger
      message = [@message, @exception.message].compact.join('. ')
      Config.logger.error message
    end

    def capture_exception
      Config.capture_exception.call(@exception) if Config.capture_exception
    end

    def handle_failure
      @on_failure.is_a?(Proc) ? @on_failure.call : @on_failure
    end
  end
end
