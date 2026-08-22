require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  test "ログインをする" do
    family = Family.create!(email: "taro@taro.com", aikotoba: "tarofamily", password: "testtest")

    visit new_families_session_path

    fill_in "あいことば", with: "tarofamily"
    fill_in "パスワード", with: "testtest"

    click_button "ログイン"

    assert_text "今日のこえ"
  end
end
