require "application_system_test_case"

class KoedayorisTest < ApplicationSystemTestCase
  test "録音ページが表示される" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    speaker = Speaker.create!(family: family, name: "テスト太郎")

    visit speaker_path(speaker.slug)

    assert_text "「こえ」を録音する"
    assert_text "押すと録音が始まります"
    assert_selector "button.recording-button[aria-label='こえの録音を始める'][aria-pressed='false']"
    assert_no_selector ".navbar"
  end
end
