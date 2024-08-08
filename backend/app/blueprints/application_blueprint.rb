class ApplicationBlueprint < Blueprinter::Base
  identifier :id

  fields :label, :model, :href

  field :attributes do |object|
    object.attributes.except("id", "created_at", "updated_at").each do |key, value|
      field key do |object|
        value
      end
    end
  end

  field :columns do |object|
    object.class.columns_hash.select { |key, value|
      !["id", "created_at", "updated_at"].include?(key)
    }.map { |key, value|
      [
        key.to_sym,
        value.type
      ]
    }
  end

  field :belongs_to do |object, options|
    associations = []
    if !options[:minimal]
      associations = object.belongs_to_associations
    end
    associations.map { |association|
      associate = object.send(association[:name].to_sym)
      associate.nil? ? nil : [
        association[:name].to_sym,
        associate.blueprinter_class.render_as_hash(associate, minimal: true)
      ]
    }.compact.to_h
  end

  field :has_one do |object, options|
    associations = []
    if !options[:minimal]
      associations = object.has_one_associations
    end
    associations.map { |association|
      associate = object.send(association[:name].to_sym)
      associate.nil? ? nil : [
        association[:name].to_sym,
        associate.blueprinter_class.render_as_hash(associate, minimal: true)
      ]
    }.compact.to_h
  end

  field :has_many do |object, options|
    associations = []
    if !options[:minimal]
      associations = object.has_many_associations
    end
    object.has_many_associations.map { |association|
      count = object.send(association[:name]).count
      label = "View #{count}"
  
      records = {}
      serve_records = options[:association] == association[:name]
      if serve_records
        records = association[:blueprinter_class].render_as_hash(
          object.send(association[:name]), 
          minimal: true
        )
      end
    
      [
        association[:name].to_sym,
        {
          label: label,
          href:  object.href(association: association[:name]),
          model: association[:model],
          count: count,
          records: records
        }
      ]
    }.to_h
  end

end