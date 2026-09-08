class Families::WithdrawalsController < Families::ApplicationController
  def new
  end

  def create
    current_family.destroy
    reset_session
    redirect_to root_path
  end
end
