class Families::ApplicationController < ApplicationController
  before_action :authenticate_family!

  private

  def authenticate_family!
    redirect_to new_families_session_path, alert: "ログインしてください" unless current_family
  end
end
