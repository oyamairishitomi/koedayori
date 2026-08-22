class HomeController < ApplicationController
  def index
    redirect_to families_speakers_path if current_family
  end
end
