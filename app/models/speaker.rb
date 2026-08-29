class Speaker < ApplicationRecord
  before_create :generate_slug
  belongs_to :family
  validates :name, presence: true

  has_many :posts, dependent: :destroy

  def notifications_needed?
    return false if posts.exists?(created_at: Time.zone.today.all_day)
    return false unless notifications_enabled
    return false unless active

    deadline = Time.current.change(hour: notify_at.hour, min: notify_at.min)
    Time.current > deadline
  end

  def today_post
    posts.find_by(created_at: Time.zone.today.all_day)
  end

  def status
    return :inactive unless active
    return :needs_attention if notifications_needed?
    :waiting
  end

  private

  def generate_slug
    self.slug = SecureRandom.alphanumeric(24)
  end
end
