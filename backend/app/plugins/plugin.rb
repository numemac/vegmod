class Plugin
  def self.active_record_callbacks
    [
      :after_create,
      :after_save,
      :after_commit,
      :after_rollback
    ]
  end
end