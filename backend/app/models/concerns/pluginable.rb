# Models that include this concern can have after_commit hooks inserted
# by 'plugin' modules. This allows for a more modular approach to adding
# business logic to models.
module Pluginable
  extend ActiveSupport::Concern

  included do
    class_attribute :plugins
    self.plugins = {}

    OldPlugin.active_record_callbacks.each do |callback|
      send(callback) do
        self.class.plugins[callback].to_a.select { |p| p[:model_class] == self.class }.each do |_plugin|
          begin
            _plugin[:plugin].send(_plugin[:callback], self)
          rescue => e
            Rails.logger.error "Plugin #{_plugin[:plugin].name} failed to run #{_plugin[:callback]} on #{self.class.name} #{self.id}"
            Rails.logger.error e

            # re-raise the error if we're in development or test
            if Rails.env.development? || Rails.env.test?
              raise e
            end
          end
        end

        true
      end
    end

    # e.g. from a plugin module 'ScreenshotRemovalPlugin':
    # Submission.plugin self, :after_commit, :remove_screenshots
    define_singleton_method :plugin do |_plugin, callback, _callback|
      self.plugins[callback] ||= []
      self.plugins[callback] << { plugin: _plugin, callback: _callback, model_class: self }
      # Rails.logger.info "Plugin #{_plugin.name} registered to #{self.name} for #{callback}"
    end
  end

end