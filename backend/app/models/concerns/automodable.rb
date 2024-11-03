module Automodable
  extend ActiveSupport::Concern

  included do
      def automod
        Automod::Configuration.new(self)
      end
  end

end