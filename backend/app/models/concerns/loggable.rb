module Loggable
  extend ActiveSupport::Concern

  included do
    has_many :logs, as: :loggable, dependent: :destroy
  end

  def logger
    @logger ||= Logger.new(self)
  end

  class Logger
    def initialize(loggable)
      @loggable = loggable
    end

    def debug(message)
      _log("debug", message)
    end

    def info(message)
      _log("info", message)
    end

    def warn(message)
      _log("warn", message)
    end

    def error(message)
      _log("error", message)
    end

    private

    def _log(level, message)
      return if level.blank? || message.blank?

      # truncate message to 255 characters
      message = message[0..254]

      Log.create!(loggable: @loggable, level: level, message: message)
    end
  end
end