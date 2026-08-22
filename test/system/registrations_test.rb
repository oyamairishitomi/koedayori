require "application_system_test_case"

class RegistrationsTest < ApplicationSystemTestCase
  test "新規登録をする" do
    visit new_families_registration_path

    fill_in "メールアドレス", with: "taro@taro.com"
    fill_in "あいことば", with: "tarofamily"
    fill_in "パスワード", with: "testtest"

    click_on "新規登録"

    assert_text "ログイン"
  end
end
