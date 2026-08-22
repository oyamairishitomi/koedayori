class Post < ApplicationRecord
  belongs_to :speaker
  belongs_to :theme, optional: true
  has_one_attached :audio
end
