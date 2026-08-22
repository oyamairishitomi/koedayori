require "application_system_test_case"

class WithdrawalsTest < ApplicationSystemTestCase
  test "退会する" do
    family = Family.create!(email: "taro@taro.com", aikotoba: "tarofamily", password: "testtest")

    visit new_families_session_path

    fill_in "あいことば", with: "tarofamily"
    fill_in "パスワード", with: "testtest"

    click_button "ログイン"

    assert_text "今日のこえ"

    click_on "設定"

    click_on "退会する"

    page.execute_script("Turbo.setConfirmMethod(() => Promise.resolve(true))")
    click_on "退会する"

    assert_text "大切な人の「こえ」で"
  end
end
