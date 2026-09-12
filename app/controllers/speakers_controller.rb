class SpeakersController < ApplicationController
  def show
    @speaker = Speaker.active.find_by!(slug: params[:slug])
    @theme = Theme.choose
  end
end
