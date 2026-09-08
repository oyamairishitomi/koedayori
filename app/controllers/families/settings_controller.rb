class Families::SettingsController < Families::ApplicationController
  def show
  end

  def update
    # ログインID(あいことば)やメールアドレスの変更は、セッションを乗っ取られた場合の
    # アカウント乗っ取りに直結するため、現在のパスワードでの再認証を求める。
    if credentials_changing? && !current_family.authenticate(params[:current_password].to_s)
      current_family.errors.add(:base, "ログイン情報を変更するには、現在のパスワードを正しく入力してください。")
      return render :show, status: :unprocessable_entity
    end

    # 先に家族情報を検証付きで更新し、成功した場合のみ話し手側の設定を反映する。
    # (update_all は検証をスキップするため、家族側の検証失敗時に不整合が残らないようにする)
    if current_family.update(settings_params.slice(:email, :aikotoba))
      if settings_params[:notify_at].present?
        current_family.speakers.update_all(notify_at: settings_params[:notify_at], notifications_enabled: true)
      end
      redirect_to families_speakers_path, notice: "設定を更新しました。"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def credentials_changing?
    (settings_params.key?("email") && settings_params["email"] != current_family.email) ||
      (settings_params.key?("aikotoba") && settings_params["aikotoba"] != current_family.aikotoba)
  end

  def settings_params
    params.permit(:email, :aikotoba, :notify_at).to_h
  end
end
