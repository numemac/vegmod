class FetchRecord < ApplicationRecord
  include Inspectable
  include Metricable
  include Pluginable
  include Loggable

  attribute :_authorized, :boolean, default: false

  self.abstract_class = true

  # override this method in subclasses
  # basically return none
  scope :full_text_search, ->(query) { where("1 = 0") }

  def self.always_include
    []
  end

  def self.computed_fields
    []
  end

  def self.blueprinter_class
    "FetchBlueprint".constantize
  end

  # the column that is queried by the route
  # e.g. /fetch?type=Reddit::Redditor&id=Nume-Macaroon224 would use the name column
  # and /fetch?type=Reddit::Subreddit&id=vegancirclejerk would use the display_name column
  # override this in subclasses, use :id as the default
  def self.fetch_column
    :id
  end

end
