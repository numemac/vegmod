class RedditRecord < ApplicationRecord
  include Inspectable
  include Pluginable

  self.abstract_class = true

  def counts
    self.class.reflect_on_all_associations(:has_many).map { |association|
      {
        name: association.name,
        count: self.send(association.name).count
      }
    }
  end

  def label
    "#{self.class.name} #{self.id}"
  end

  def self.detail_association
    [] # won't cause an error if not defined
  end

  def detail_label
    if self.class.detail_association.is_a? Symbol
      self.send(self.class.detail_association)&.label
    else
      ""
    end
  end

  def detail_href
    if self.class.detail_association.is_a? Symbol
      self.send(self.class.detail_association)&.href
    else
      nil
    end
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

  def app_url(association: nil)
    if association
      "#{ENV['RAILS_HOST']}/inspect?model=#{model}&id=#{id}&association=#{association}"
    else
      "#{ENV['RAILS_HOST']}/inspect?model=#{model}&id=#{id}"
    end
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

  def self.has_many_associations
    self.reflect_on_all_associations(:has_many).reject { |association|
      association.options[:polymorphic]
    }.reject { |association|
      !association.klass.respond_to?(:inspectable?) 
    }.map { |association|
      {
        name: association.name,
        model: model,
        class_name: association.class_name,
        klass: association.klass,
        blueprinter_class: association.klass.blueprinter_class
      }
    }
  end

  def self.has_one_associations
    self.reflect_on_all_associations(:has_one).map { |association|
      {
        name: association.name,
      }
    }
  end

  def self.belongs_to_associations
    self.reflect_on_all_associations(:belongs_to).map { |association|
      {
        name: association.name,
      }
    }
  end

end
