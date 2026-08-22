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
end
