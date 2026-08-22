class Families::SessionsController < Families::ApplicationController
  skip_before_action :authenticate_family!

  def new
    redirect_to families_speakers_path if current_family
  end

  def create
    family = Family.find_by(aikotoba: params[:family][:aikotoba])

    if family&.authenticate(params[:family][:password])
      session[:family_id] = family.id
      redirect_to families_speakers_path
    else
      flash.now[:alert] = "ログインに失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:family_id)
    redirect_to root_path
  end
end
