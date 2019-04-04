class WebMagazineGroup < ApplicationRecord
  default_scope { order("CREATED_AT") }
  has_many :web_magazines
end
