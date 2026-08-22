class Family < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :aikotoba, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, allow_nil: true
  validates :privacy_agreement, acceptance: true
  validates :terms_agreement, acceptance: true

  has_many :speakers, dependent: :destroy
  has_many :posts, through: :speakers

  def status_for_dashboard
    { needs_attention: 0, needs_read: 0, confirmed: 0 }.merge(speakers.map(&:status).tally)
  end
end
