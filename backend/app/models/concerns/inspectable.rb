module Inspectable
  extend ActiveSupport::Concern

  included do
  
    def inspectable?
      true
    end

    def self.inspectable?
      true
    end

  end
end