class SpeakersController < ApplicationController
  def show
    @theme = Theme.choose
  end
end
