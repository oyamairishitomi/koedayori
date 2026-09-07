class PostsController < ApplicationController
  def create
    speaker = Speaker.find_by!(slug: params[:slug])
    post = speaker.posts.new(theme: Theme.find(params[:theme_id]))
    post.audio.attach(params[:audio])

    if post.save
      render json: { status: "ok" }
    else
      render json: { status: "error", errors: post.errors.full_messages }
    end
  end
end
