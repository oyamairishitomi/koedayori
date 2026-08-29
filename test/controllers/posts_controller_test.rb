require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "正しいslugに音声を送るとPostが作成される" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    speaker = Speaker.create!(family: family, name: "テスト太郎")

    audio_file = fixture_file_upload("test_audio.webm", "audio/webm")

    assert_difference "Post.count", 1 do
      post "/speakers/#{speaker.slug}/posts", params: { audio: audio_file }
    end

    assert_response :success
  end

  test "存在しないslugに送ると404になる" do
    audio_file = fixture_file_upload("test_audio.webm", "audio/webm")

    assert_no_difference "Post.count" do
      post "/speakers/nonexistent-slug/posts", params: { audio: audio_file }
    end

    assert_response :not_found
  end

  test "音声ファイルがないとPostが作成されない" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    speaker = Speaker.create!(family: family, name: "テスト太郎")

    assert_no_difference "Post.count" do
      post "/speakers/#{speaker.slug}/posts"
    end

    response_body = JSON.parse(response.body)
    assert_equal "error", response_body["status"]
    assert(response_body["errors"].any? { |message| message.include?("入力してください") })
  end

  test "音声以外のファイルを送るとPostが作成されない" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    speaker = Speaker.create!(family: family, name: "テスト太郎")

    text_file = fixture_file_upload("test_document.txt", "text/plain")

    assert_no_difference "Post.count" do
      post "/speakers/#{speaker.slug}/posts", params: { audio: text_file }
    end

    response_body = JSON.parse(response.body)
    assert_equal "error", response_body["status"]
    assert(response_body["errors"].any? { |message| message.include?("適切な音声データ") })
  end
end
