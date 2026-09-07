require "application_system_test_case"

class RegistrationsTest < ApplicationSystemTestCase
  test "新規登録をする" do
    visit new_families_registration_path

    fill_in "メールアドレス", with: "taro@example.com"
    fill_in "あいことば", with: "tarofamily"
    fill_in "パスワード", with: "testtest"

    check "プライバシーポリシーに同意する"
    check "利用規約に同意する"

    assert_difference "Family.count", 1 do
      click_on "登録する"
      assert_text "ログイン"

      assert_current_path new_families_session_path
    end
  end
end
