class Families::SettingsController < Families::ApplicationController
  def show
  end

  def update
    current_family.speakers.update_all(notifications_enabled: true, notify_at: params[:notify_at])
    current_family.update(aikotoba: params[:aikotoba], email: params[:email])
    redirect_to families_speakers_path, notice: "設定を更新しました"
  end
end
