module Families::SpeakersHelper
  def speaker_qrcode
    @qrcode_srv = RQRCode::QRCode.new(speaker_share_url(@speaker)).as_svg(module_size: 4).html_safe
  end

  def speaker_share_url(speaker)
    speaker_url(speaker.slug, openExternalBrowser: 1)
  end
end
