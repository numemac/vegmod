class FetchBlueprint < ApplicationBlueprint

  def self.authorize(rel, ability)
    return rel if ability.nil?

    # check if rel is ActiveRecord::Relation
    if rel.is_a?(ActiveRecord::Relation)
      return rel.accessible_by(ability).map do |record|
        record[:_authorized] = true
        record
      end
    end

    if ability.can?(:read, rel)
      rel[:_authorized] = true
      return rel
    end

    Rails.logger.info "Ability user cannot read #{rel.inspect}"
    raise CanCan::AccessDenied
  end

  field :_authorized do |object, options|
    object.try(:_authorized)
  end

  field :_type do |object, options|
    object.class.name
  end

  # columns + computed_fields
  field :attributes do |object, options|
    attributes = {}

    unless options.has_key?(:attributes) && !options[:attributes]
      object_attributes = object.attributes

      # If object is 'User' then remove sensitive information
      if object.class.name == User.name
        object_attributes = {
          email: object.email,
          dark_mode: object.dark_mode,
          created_at: object.created_at,
          updated_at: object.updated_at,
        }
      end

      object_attributes.each do |key, value|
        next if key == "_authorized"
        attributes[key] = value
      end

      object.class.computed_fields.each do |field|
        attributes[field] = object.send(field)
      end
    end

    attributes
  end

  field :associations do |object, options|
    associations = {}

    object.class.always_include.each do |association|
      if object.respond_to?(association)
        associations[association] = authorize(
          object.send(association),
          options[:ability]
        ).as_json()
      end
    end

    if options[:associations].present? && options[:associations].is_a?(Array)
      response = {}
      without_defaults = options[:associations] - object.class.always_include
      without_defaults.each do |association|
        if object.respond_to?(association)
          value = object.send(association)
          if value.is_a?(ActiveRecord::Relation)
            if options[:offset].present?
              value = value.offset(options[:offset])
            end
            if options[:limit].present?
              value = value.limit(options[:limit])
            end
          end
          associations[association] = authorize(
            value.is_a?(ActiveRecord::Relation) ? value.order(id: :desc) : value,
            options[:ability]
          ).as_json()
        end
      end
    end

    associations
  end
end