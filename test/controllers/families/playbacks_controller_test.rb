require "test_helper"

class Families::PlaybacksControllerTest < ActionDispatch::IntegrationTest
  test "再生されると既読(played_at)になる" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    speaker = Speaker.create!(family: family, name: "テスト太郎")
    post_record = speaker.posts.create!(created_at: Time.current)

    post families_sessions_path, params: { family: { aikotoba: "aaa", password: "password123" } }
    post "/families/playbacks/#{post_record.id}"

    assert_response :ok
    assert post_record.reload.played_at.present?
  end
end
