class Families::PostsController < Families::ApplicationController
  def index
    @speaker = current_family.speakers.find(params[:speaker_id])
    @posts = @speaker.posts.order(created_at: :desc).page(params[:page])
  end
end
