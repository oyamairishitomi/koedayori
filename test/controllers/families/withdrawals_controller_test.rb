require "test_helper"

class Families::WithdrawalsControllerTest < ActionDispatch::IntegrationTest
  test "退会するとFamily.Speaker.Postが全部削除される" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    speaker = Speaker.create!(family: family, name: "テスト太郎")
    post_record = speaker.posts.create!(created_at: Time.current, audio: fixture_file_upload("test_audio.webm", "audio/webm"))

    post families_sessions_path, params: { family: { aikotoba: "aaa", password: "password123" } }
    post families_withdrawals_path

    assert_redirected_to root_path
    assert_not Family.exists?(family.id)
    assert_not Speaker.exists?(speaker.id)
    assert_not Post.exists?(post_record.id)
  end
end
