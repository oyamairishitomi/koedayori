module Families::SpeakersHelper
  def speaker_qrcode
    @qrcode_srv = RQRCode::QRCode.new(speaker_share_url(@speaker)).as_svg(module_size: 4).html_safe
  end

  def speaker_share_url(speaker)
    speaker_url(speaker.slug, openExternalBrowser: 1)
  end

  def make_graph
    total = current_family.status_for_dashboard.values_at(:needs_attention, :needs_read, :confirmed).sum
    if total.zero?
      "#888888"
    else
      @num_needs_attention = current_family.status_for_dashboard[:needs_attention].to_f / total * 100
      @num_needs_read = current_family.status_for_dashboard[:needs_read].to_f / total * 100
      @num_confirmed = current_family.status_for_dashboard[:confirmed].to_f / total * 100

      @cumulative_needs_read = @num_needs_attention + @num_needs_read

      "conic-gradient(var(--color-error) 0% #{@num_needs_attention}%, var(--color-warning) #{@num_needs_attention}% #{@cumulative_needs_read}%, var(--color-success) #{@cumulative_needs_read}% 100%)"
    end
  end
end
