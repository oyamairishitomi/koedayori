require "test_helper"

class Families::PostControllerTest < ActionDispatch::IntegrationTest
  test "こえがない場合は録音準備へのボタンを表示する" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    speaker = Speaker.create!(family: family, name: "テスト太郎")
    post families_sessions_path, params: { family: { aikotoba: "aaa", password: "password123" } }

    get families_speaker_posts_path(speaker)

    assert_response :success
    assert_select "a.btn[href='#{families_speaker_path(speaker)}']", text: /録音の準備方法を\s*開始する/
  end

  test "こえ一覧に再生状況を表示しない" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    speaker = Speaker.create!(family: family, name: "テスト太郎")
    post_record = speaker.posts.create!(created_at: Time.current, audio: { io: File.open(Rails.root.join("test/fixtures/files/test_audio.webm")), filename: "test_audio.webm", content_type: "audio/webm" })
    post families_sessions_path, params: { family: { aikotoba: "aaa", password: "password123" } }

    get families_speaker_posts_path(speaker)

    assert_response :success
    assert_select "h1", "テスト太郎さんのこえ"
    assert_select "input[type=range][aria-label='再生位置']"
    assert_select "a.link:not(.btn)", text: /今日の「こえ」に戻る/
    assert_no_match(/誰かが|確認されていません|既読/, response.body)
  end
end
