class Families::RegistrationsController < Families::ApplicationController
  skip_before_action :authenticate_family!

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(family_params)

    if @family.save
      redirect_to new_families_session_path, notice: "登録が完了しました。ログインしてください。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def family_params
    params.require(:family).permit(:email, :aikotoba, :password, :privacy_agreement, :terms_agreement)
  end
end
