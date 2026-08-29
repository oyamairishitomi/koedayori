class Families::SettingsController < Families::ApplicationController
  def show
  end

  def update
    current_family.speakers.update_all(settings_params.slice(:notify_at).merge(notifications_enabled: true))

    if current_family.update(settings_params.slice(:email, :aikotoba))
      redirect_to families_speakers_path, notice: "設定を更新しました。"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def settings_params
    params.permit(:email, :aikotoba, :notify_at).to_h
  end
end
