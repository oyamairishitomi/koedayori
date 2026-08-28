require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  test "ログインをする" do
    family = Family.create!(email: "taro@taro.com", aikotoba: "tarofamily", password: "testtest")

    visit new_families_session_path

    fill_in "あいことば", with: "tarofamily"
    fill_in "パスワード", with: "testtest"

    click_button "ログイン"

    assert_text "今日の「こえ」"
    assert_selector "#success_explanation[data-controller='auto-dismiss'][data-auto-dismiss-delay-value='5000']", text: "ログインしました。"
    assert_no_selector "#success_explanation", wait: 6
  end
end
