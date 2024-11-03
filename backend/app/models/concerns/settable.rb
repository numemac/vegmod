module Settable
  extend ActiveSupport::Concern

  included do
    def self.settable?
      true
    end

    def settable?
      true
    end
  end

end