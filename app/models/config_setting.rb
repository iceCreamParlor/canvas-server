class ConfigSetting < ApplicationRecord

  class << self
    def get_web_magazines
      str = self.where(key: "web_magazines").last&.value
      if str
        WebMagazine.where(number: str.split(",").map { |s| s.to_i })
      else
        WebMagazine.last(3)
      end
    end
  end

end
