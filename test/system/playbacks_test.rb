require "application_system_test_case"

class PlaybacksTest < ApplicationSystemTestCase
  test "既読にする" do
    family = Family.create!(email: "taro@taro.com", aikotoba: "tarofamily", password: "testtest")
    speaker = Speaker.create!(family: family, name: "テスト太郎")
    post = speaker.posts.create!(created_at: Time.current)
    post.audio.attach(io: File.open(Rails.root.join("test/fixtures/files/test_audio.webm")), filename: "test_audio.webm")

    visit new_families_session_path

    fill_in "あいことば", with: "tarofamily"
    fill_in "パスワード", with: "testtest"

    click_button "ログイン"

    assert_text "今日のこえ"

    click_on "テスト太郎"

    find("[data-playback-target='playButton']").click

    assert_text "既読"
  end
end
