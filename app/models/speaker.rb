class Speaker < ApplicationRecord
  before_create :generate_slug
  belongs_to :family
  validates :name, presence: true

  has_many :posts, dependent: :destroy

  def notifications_needed?
    return false if posts.find { |post| post.created_at.to_date == Time.zone.today }
    return false unless notifications_enabled
    return false unless active

    deadline = Time.current.change(hour: notify_at.hour, min: notify_at.min)

    if Time.current > deadline
      true
    else
      false
    end
  end

  def today_post
    posts.find { |post| post.created_at.to_date == Time.zone.today }
  end

  def show_read_status?
    active? && !notifications_needed?
  end

  def played?
    today_post&.played_at?
  end

  def status
    return :inactive unless active
    return :needs_attention if notifications_needed?
    return :confirmed if played?
    return :needs_read if today_post
    :waiting
  end

  private

  def generate_slug
    self.slug = SecureRandom.alphanumeric(24)
  end
end
