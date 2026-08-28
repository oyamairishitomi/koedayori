require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "プライバシーポリシーを表示できる" do
    get privacy_path

    assert_response :success
    assert_select "h1", "プライバシーポリシー"
  end

  test "利用規約を表示できる" do
    get terms_path

    assert_response :success
    assert_select "h1", "利用規約"
  end
end
