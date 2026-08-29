require "test_helper"

class Families::SpeakersControllerTest < ActionDispatch::IntegrationTest
  test "有効な名前の家族（Speaker）を追加する" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    post families_sessions_path, params: { family: { aikotoba: "aaa", password: "password123" } }
    post families_speakers_path, params: { speaker: { name: "テスト太郎" } }
    assert_redirected_to families_speaker_path(Speaker.last)
  end

  test "無効な名前の家族（Speaker）の追加に失敗する" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    post families_sessions_path, params: { family: { aikotoba: "aaa", password: "password123" } }
    post families_speakers_path, params: { speaker: { name: nil } }
    assert_response :unprocessable_entity
  end

  test "受け取り停止にするとactiveがfalseになり、データは残る" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    speaker = Speaker.create!(family: family, name: "テスト太郎")
    post_record = speaker.posts.create!(audio: fixture_file_upload("test_audio.webm", "audio/webm"))

    post families_sessions_path, params: { family: { aikotoba: "aaa", password: "password123" } }
    patch deactivate_families_speaker_path(speaker)

    assert_redirected_to families_speakers_path
    assert_not speaker.reload.active
    assert Speaker.exists?(speaker.id)
    assert Post.exists?(post_record.id)
  end
end
