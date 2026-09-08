require "test_helper"

class Families::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "新規登録するとFamilyが作成される" do
    assert_difference "Family.count", 1 do
      post families_registrations_path, params: { family: { email: "a@example.com", aikotoba: "aaa", password: "password123", privacy_agreement: "1", terms_agreement: "1" } }
    end
  end
end
