class RedditBlueprint < ApplicationBlueprint
  fields :label, :model, :href

  field :image_url do |object|
    object.respond_to?(:imageable?) ? object.image_url : nil
  end

  field :detail_label do |object, options|
    options[:depth] <= 2 ? object.detail_label : nil
  end

  field :detail_href do |object, options|
    options[:depth] <= 2 ? object.detail_href : nil
  end
  
  field :attributes do |object|
    attributes = object.attributes.except("id", "created_at", "updated_at")
    attributes.each do |key, value|
      field key do |object|
        value
      end
    end
  end

  field :belongs_to do |object, options|
    associations = options[:depth] && options[:depth] <= 2 ? object.class.belongs_to_associations : []
    associations.map { |association|
      associate = object.send(association[:name].to_sym)
      (associate.nil? || !associate.respond_to?(:inspectable?)) ? nil : [
        association[:name].to_sym,
        associate.as_hash(**options.merge(depth: options[:depth] + 1))
      ]
    }.compact.to_h
  end

  field :has_one do |object, options|
    associations = options[:depth] && options[:depth] == 1 ? object.class.has_one_associations : []
    associations.map { |association|
      associate = object.send(association[:name].to_sym)
      (associate.nil? || !associate.respond_to?(:inspectable?)) ? nil : [
        association[:name].to_sym,
        associate.as_hash(**options.merge(depth: options[:depth] + 1))
      ]
    }.compact.to_h
  end

  field :has_many do |object, options|
    associations = options[:depth] && options[:depth] == 1 ? object.class.has_many_associations : []
    associations.map { |association|
      count = object.send(association[:name]).count
      label = "View #{count}"
  
      records = {}
      serve_records = options[:association] == association[:name]
      if serve_records
        records = association[:blueprinter_class].render_as_hash(
          object.send(association[:name]).includes(association[:klass].detail_association).order(updated_at: :desc),
          **options.merge(depth: options[:depth] + 1)
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