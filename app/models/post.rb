class Post < ApplicationRecord
  belongs_to :speaker
  belongs_to :theme, optional: true
  has_one_attached :audio

  validates :audio, presence: true
  validate :audio_content_type
  validate :audio_size

  def created_at_label
    if created_at.to_date == Time.zone.today
      "今日 #{created_at.strftime("%H:%M")}"
    else
      created_at.strftime("%Y年%-m月%-d日 %H:%M")
    end
  end

  def arrived_message
    theme_part = theme&.title.present? ? "「#{theme.title}」の" : ""
    "#{created_at_label} に#{theme_part}「こえ」が届きました。"
  end

  def elapsed_hours
    [ ((Time.current - created_at) / 1.hour).floor, 0 ].max
  end

  def elapsed_label
    return "最後の投稿から1時間未満" if elapsed_hours.zero?

    "最後の投稿から#{elapsed_hours}時間経過"
  end

  def elapsed_warning?
    elapsed_hours >= 30
  end

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
