class Post < ApplicationRecord
  belongs_to :speaker
  belongs_to :theme, optional: true
  has_one_attached :audio

  validates :audio, presence: true
  validate :audio_content_type
  validate :audio_size

  private

  def audio_content_type
    return unless audio.attached?

    allowed_types = [ "audio/mpeg", "audio/mp4", "audio/wav", "audio/webm" ]
    unless allowed_types.include?(audio.content_type.split(";").first)
      audio.purge
      errors.add(:audio, "適切な音声データが送られていません。")
    end
  end

  def audio_size
    return unless audio.attached?

    max_size = 100.megabytes
    if audio.byte_size > max_size
      errors.add(:audio, "音声が長すぎます")
    end
  end
end
