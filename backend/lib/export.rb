class Export
  def self.json(data)
    # unix timestamp
    path = Rails.root.join('data', 'egress', "#{Time.now.to_i}.json")
    File.open(path, 'w') do |file|
      file.write(data.to_json)
    end
    path
  end
end