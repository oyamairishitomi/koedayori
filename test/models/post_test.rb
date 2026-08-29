require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "音声ファイルが添付されていないと無効" do
    post = Post.new(speaker: speakers(:one))
    assert_not post.valid?
    assert_includes post.errors[:audio], "を入力してください"
  end

  test "音声以外のcontent_typeなら無効" do
    post = Post.new(speaker: speakers(:one))
    post.audio.attach(
      io: File.open(Rails.root.join("test/fixtures/files/test_document.txt")),
      filename: "test_document.txt",
      content_type: "text/plain"
    )

    assert_not post.valid?
    assert_includes post.errors[:audio], "適切な音声データが送られていません。"
  end

  test "音声のcontent_typeなら有効" do
    post = Post.new(speaker: speakers(:one))
    post.audio.attach(
      io: File.open(Rails.root.join("test/fixtures/files/test_audio.webm")),
      filename: "test_audio.webm",
      content_type: "audio/webm"
    )

    assert post.valid?
  end

  test "サイズが上限を超えていたら無効" do
    post = Post.new(speaker: speakers(:one))
    post.audio.attach(
      io: StringIO.new("a" * 11.megabytes),
      filename: "big.webm",
      content_type: "audio/webm"
    )

    assert_not post.valid?
    assert_includes post.errors[:audio], "音声が長すぎます"
  end
end
