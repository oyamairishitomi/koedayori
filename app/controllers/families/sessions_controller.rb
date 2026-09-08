class Families::SessionsController < Families::ApplicationController
  skip_before_action :authenticate_family!

  # 合言葉＋パスワードの総当たり・クレデンシャルスタッフィングを抑止する。
  rate_limit to: 10, within: 3.minutes, only: :create,
    with: -> { redirect_to new_families_session_path, alert: "試行回数が多すぎます。しばらくしてからお試しください。" }

  # 合言葉が存在しない場合でも bcrypt を実行するためのダミーダイジェスト。
  # 「合言葉が見つからないと即座に失敗する」時間差から有効な合言葉を推測されるのを防ぐ。
  DUMMY_PASSWORD_DIGEST = BCrypt::Password.create("timing-attack-guard").to_s.freeze

  def new
    redirect_to families_speakers_path if current_family
  end

  def create
    family = Family.find_by(aikotoba: params[:family][:aikotoba])

    if family&.authenticate(params[:family][:password])
      # ログイン(権限昇格)時にセッションIDを再生成し、セッション固定攻撃を防ぐ。
      reset_session
      session[:family_id] = family.id
      redirect_to families_speakers_path, notice: "ログインしました。"
    else
      # 合言葉が存在しなくても bcrypt 相当の処理時間を消費し、応答時間を揃える。
      BCrypt::Password.new(DUMMY_PASSWORD_DIGEST).is_password?(params[:family][:password].to_s) unless family
      flash.now[:alert] = "ログインに失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
