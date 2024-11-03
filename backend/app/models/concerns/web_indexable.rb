module WebIndexable
  extend ActiveSupport::Concern

  included do
    def web_indexable?
      true
    end

    def self.web_indexable?
      true
    end
  end

end