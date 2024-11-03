class Plugins::AbstractPlugin

  def self.title
    raise NotImplementedError
  end

  def self.description
    raise NotImplementedError
  end

  def self.author
    raise NotImplementedError
  end

  def self.spec
    raise NotImplementedError
  end

  def self.default_config
    spec.map do |key, value|
      [key, value[:default]]
    end.to_h
  end

  def initialize(subreddit_plugin, record)
    @subreddit_plugin = subreddit_plugin
    @subreddit        = subreddit_plugin.subreddit
    @plugin           = subreddit_plugin.plugin
    @config           = subreddit_plugin.config
    @logger           = subreddit_plugin.logger
    @record           = record
  end

  def notify
    begin
      if conditions_met?
        execute
        @subreddit_plugin.update(
          executions: @subreddit_plugin.executions + 1,
          last_executed_at: Time.now
        )
      end
    rescue StandardError => e
      @logger.error e.message
      @subreddit_plugin.update(
        failures: @subreddit_plugin.failures + 1,
        last_failed_at: Time.now
      )
    end
  end

  def conditions_met?
    raise NotImplementedError
  end

  def execute
    raise NotImplementedError
  end

end