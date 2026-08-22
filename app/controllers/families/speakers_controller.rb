class Families::SpeakersController < Families::ApplicationController
  def index
  end

  def show
    @speaker = current_family.speakers.find(params[:id])
  end

  def update
    @speaker = current_family.speakers.find(params[:id])
    if @speaker.update(speakers_params)
      redirect_to families_speakers_path
    else
      render :edit
    end
  end

  def deactivate
    @speaker = current_family.speakers.find(params[:id])
    if @speaker.update(active: false)
      redirect_to families_speakers_path
    else
      render :edit
    end
  end

  def edit
    @speaker = current_family.speakers.find(params[:id])
  end

  def new
    @speaker = current_family.speakers.new
  end

  def create
    @speaker = current_family.speakers.new(speakers_params)

    if @speaker.save
      redirect_to families_speaker_path(@speaker), notice: "ご家族の登録が完了しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def speakers_params
    params.require(:speaker).permit(:name, :notify_at, :notifications_enabled, :active)
  end
end
