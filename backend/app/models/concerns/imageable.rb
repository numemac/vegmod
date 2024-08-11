module Imageable
  extend ActiveSupport::Concern

  included do
    has_one_attached :image, dependent: :destroy

    def image_url
      image.attached? ? Rails.application.routes.url_helpers.rails_storage_proxy_url(image, only_path: true) : nil
    end

    def image_url_x256
      image.attached? ? Rails.application.routes.url_helpers.rails_storage_proxy_url(image.variant(resize_to_fit: [256, nil]), only_path: true) : nil
    end

    def image_url_x512
      image.attached? ? Rails.application.routes.url_helpers.rails_storage_proxy_url(image.variant(resize_to_fit: [512, nil]), only_path: true) : nil
    end

    def image_url_x1024
      image.attached? ? Rails.application.routes.url_helpers.rails_storage_proxy_url(image.variant(resize_to_fit: [1024, nil]), only_path: true) : nil
    end

    def imageable?
      true
    end

    def self.imageable?
      true
    end
  end

end