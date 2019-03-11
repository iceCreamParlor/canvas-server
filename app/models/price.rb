class Price < ApplicationRecord
  default_scope { order("value asc") }
end
