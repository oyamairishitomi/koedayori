require "test_helper"

class SpeakersControllerTest < ActionDispatch::IntegrationTest
  test "正しいslugにアクセスすると録音ページが表示される" do
    family = Family.create!(email: "test@example.com", aikotoba: "aaa", password: "password123")
    speaker = Speaker.create!(family: family, name: "テスト太郎")

    get "/speakers/#{speaker.slug}"

    assert_response :success
  end

  test "存在しないslugにアクセスすると404になる" do
    get "/speakers/nonexistent-slug"

    assert_response :not_found
  end

  test "受け取り停止中のSpeakerのslugにアクセスすると404になる" do
    family = Family.create!(email: "test@example.com", aikotoba: "aaa", password: "password123")
    speaker = Speaker.create!(family: family, name: "テスト太郎", active: false)

    get "/speakers/#{speaker.slug}"

    assert_response :not_found
  end
end
