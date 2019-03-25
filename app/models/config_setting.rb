class ConfigSetting < ApplicationRecord

  class << self
    def get_web_magazines
      str = self.where(key: "web_magazines").last&.value
      if str
        WebMagazine.where(id: str.split(",").map { |s| s.to_i }).order("NUMBER")
      else
        WebMagazine.last(3).order("NUMBER")
      end
    end
  end

end
