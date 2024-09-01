module Externalable
  extend ActiveSupport::Concern

  included do
      def externalable?
        true
      end
  
      def self.externalable?
        true
      end

      def external_url
        raise "external_url not implemented"
      end
  end

end