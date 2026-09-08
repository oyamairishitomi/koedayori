class Theme < ApplicationRecord
  has_many :posts

  def self.choose
    return if count.zero?

    theme_index = Date.current.yday % count
    order(:id).offset(theme_index).first
  end
end
