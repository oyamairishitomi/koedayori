class SpeakersController < ApplicationController
  def show
    @speaker = Speaker.find_by!(slug: params[:slug])
    @theme = Theme.choose
  end
end
