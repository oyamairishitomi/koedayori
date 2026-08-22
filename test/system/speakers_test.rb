require "application_system_test_case"

class SpeakersTest < ApplicationSystemTestCase
  test "ご家族の受け取り停止" do
    skip "設定画面から利用停止への導線が未実装のため一時スキップ"
    family = Family.create!(email: "taro@taro.com", aikotoba: "tarofamily", password: "testtest")
    speaker = Speaker.create!(family: family, name: "テスト太郎")

    visit new_families_session_path

    fill_in "あいことば", with: "tarofamily"
    fill_in "パスワード", with: "testtest"

    click_button "ログイン"

    click_on "設定"

    click_on "通知設定"

    page.execute_script("Turbo.setConfirmMethod(() => Promise.resolve(true))")
    click_on "こえの受け取りを終了する"

    assert_text "今日のこえ"
  end
end
