class Log < FetchRecord
  belongs_to :loggable, polymorphic: true

  def to_s
    "[#{self.created_at}] #{self.level}: #{self.message}"
  end
end