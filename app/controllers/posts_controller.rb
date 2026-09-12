class PostsController < ApplicationController
  # slug さえ分かれば無認証で投稿できるため、IP単位で投稿数を制限し、
  # 大容量音声の大量アップロードによるストレージ・転送コストの枯渇を防ぐ。
  rate_limit to: 20, within: 1.minute, only: :create,
    with: -> { render json: { status: "error", errors: [ "しばらくしてからもう一度お試しください。" ] }, status: :too_many_requests }

  def create
    speaker = Speaker.active.find_by!(slug: params[:slug])
    post = speaker.posts.new(theme: Theme.find(params[:theme_id]))
    post.audio.attach(params[:audio])

    if post.save
      render json: { status: "ok" }
    else
      render json: { status: "error", errors: post.errors.full_messages }
    end
  end
end
