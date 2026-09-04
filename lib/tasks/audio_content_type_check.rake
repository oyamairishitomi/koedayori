# content_typeが"audio/webm"と記録されている投稿の音声ファイルについて、
# 実際のファイルの先頭バイト(マジックナンバー)を見て、中身が本当にwebmかmp4かを調べる。
# 何も変更しない、調査専用タスクです！
#
# 実行方法:
#   bin/rails posts:check_audio_content_type
#   (本番で実行する場合は bin/kamal app exec "bin/rails posts:check_audio_content_type")

namespace :posts do
  desc "content_typeが audio/webm な投稿の実際のファイル形式を調べる(読み取り専用)"
  task check_audio_content_type: :environment do
    webm_magic = "\x1A\x45\xDF\xA3".b

    target_posts = Post.joins(audio_attachment: :blob)
                        .where(active_storage_blobs: { content_type: "audio/webm" })

    puts "content_type=audio/webm の投稿: #{target_posts.count}件"
    puts "---"

    mismatch_count = 0

    target_posts.find_each do |post|
      blob = post.audio.blob
      head = blob.download_chunk(0..11)

      actual_format =
        if head[0, 4] == webm_magic
          :webm
        elsif head[4, 4] == "ftyp"
          :mp4
        else
          :unknown
        end

      next if actual_format == :webm

      mismatch_count += 1
      puts "Post ##{post.id} (speaker_id=#{post.speaker_id}, created_at=#{post.created_at}): " \
           "content_type=audio/webm だが実際は #{actual_format} (先頭12バイト: #{head.unpack1("H*")})"
    end

    puts "---"
    puts "食い違いが見つかった件数: #{mismatch_count}件 / #{target_posts.count}件"
  end
end
