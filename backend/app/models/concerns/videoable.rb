module Videoable
  extend ActiveSupport::Concern

  included do
    has_one_attached :video, dependent: :destroy

    def video_url
      image.attached? ? Rails.application.routes.url_helpers.rails_storage_proxy_url(video, only_path: true) : nil
    end

    def videoable?
      true
    end

    def self.videoable?
      true
    end
  end

end