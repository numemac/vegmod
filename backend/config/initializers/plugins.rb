# Load plugins located in lib/plugins
# For each one create a record in the plugins table
#
# This script is meant to be run on-startup of the Rails application
# to ensure that all plugins are loaded into the database.

# Load all plugins
# Dir[Rails.root.join("lib/plugins/*.rb")].each { |file| require file }

# Skip if the table doesn't exist
# This is to prevent errors during migrations

def process_spec(spec)
  spec = spec.map { |key, value|
    [key, value.merge(_order: spec.keys.index(key))]
  }.to_h

  # add multiline: false to all spec items without one declared
  # if one is declared, keep it
  spec = spec.map { |key, value|
    [key, value.key?(:multiline) ? value : value.merge(multiline: false)]
  }.to_h

  spec
end

ActiveSupport::Reloader.to_prepare do
  return unless ActiveRecord::Base.connection.table_exists?("plugins")

  success = 0
  failure = 0

  Dir[Rails.root.join("lib/plugins/*.rb")].each { |file| require file }
  loaded = Plugins::AbstractPlugin.descendants.map { |klass|
    plugin = nil    

    begin
      processed_spec = process_spec(klass.spec)

      plugin = Plugin.find_or_create_by(
        klass: klass.name
      ) { |p|
        p.title = klass.title
        p.description = klass.description
        p.author = klass.author
        p.spec = processed_spec,
        p.loaded = true
      }

      # update the plugin
      plugin.update(
        title: klass.title,
        description: klass.description,
        author: klass.author,
        spec: processed_spec,
        loaded: true
      )

      success += 1
    rescue StandardError => e
      Rails.logger.error "Failed to load plugin #{klass.name}: #{e.message}"
      failure += 1
    end

    plugin
  }

  Plugin.where.not(id: loaded.map(&:id)).update_all(loaded: false)

  Rails.logger.info "Successfully loaded #{success} plugins, with #{failure} failures."
end