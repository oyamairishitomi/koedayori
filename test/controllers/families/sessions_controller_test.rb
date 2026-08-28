require "test_helper"

class Families::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "正しいあいことばとパスワードでログインできる" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    post families_sessions_path, params: { family: { aikotoba: "aaa", password: "password123" } }
    assert_redirected_to families_speakers_path
    assert_equal "ログインしました。", flash[:notice]
  end

  test "異なるあいことばとパスワードでログインできない" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    post families_sessions_path, params: { family: { aikotoba: "aaa", password: "123password" } }
    assert_response :unprocessable_entity
  end
end
