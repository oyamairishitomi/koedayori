require "test_helper"

class Families::PostsControllerTest < ActionDispatch::IntegrationTest
  test "他の家族のスピーカーの投稿一覧は見れない" do
    family_a = Family.create!(email: "a@example.com", aikotoba: "aaa", password: "password123")
    family_b = Family.create!(email: "b@example.com", aikotoba: "bbb", password: "password123")
    speaker_a = Speaker.create!(family: family_a, name: "テストA")

    post families_sessions_path, params: { family: { aikotoba: family_b.aikotoba, password: "password123" } }

    get families_speaker_posts_path(speaker_a)

    assert_response :not_found
  end
end
