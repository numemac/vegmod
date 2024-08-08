class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def label
    "#{self.class.name} #{self.id}"
  end

  def self.model
    self.name.underscore.downcase.pluralize
  end

  def model
    self.class.model
  end

  def href(association: nil)
    {
      pathname: '/inspect',
      query: {
        model: model,
        id: id,
        association: association
      }
    }
  end

  def self.blueprinter_class
    "#{self.name}Blueprint".constantize
  end
  
  def blueprinter_class
    "#{self.class.name}Blueprint".constantize
  end

  # override the default as_json method to use blueprinter
  def as_json(options = {})
    blueprinter_class.render_as_hash(self, options)
  end

  def as_hash(options = {})
    blueprinter_class.render_as_hash(self, options)
  end

  def has_many_associations
    self.class.reflect_on_all_associations(:has_many).reject { |association|
      association.options[:polymorphic]
    }.map { |association|
      {
        name: association.name,
        model: model,
        class_name: association.class_name,
        blueprinter_class: association.klass.blueprinter_class
      }
    }
  end

  def has_one_associations
    self.class.reflect_on_all_associations(:has_one).map { |association|
      {
        name: association.name,
      }
    }
  end

  def belongs_to_associations
    self.class.reflect_on_all_associations(:belongs_to).map { |association|
      {
        name: association.name,
      }
    }
  end

end
