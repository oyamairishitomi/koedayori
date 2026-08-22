require "application_system_test_case"

class KoedayorisTest < ApplicationSystemTestCase
  test "録音ページが表示される" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    speaker = Speaker.create!(family: family, name: "テスト太郎")

    visit speaker_path(speaker.slug)

    assert_text "こえの吹き込み"
  end
end
