require "test_helper"

class FamilyTest < ActiveSupport::TestCase
  test "email, aikotoba, passwordが揃っていれば有効" do
    family = Family.new(email: "test@test.com", aikotoba: "aaa", password: "password123")
    assert family.valid?
  end

  test "emailが欠如で無効" do
    family = Family.new(email: "", aikotoba: "aaa", password: "password123")
    assert_not family.valid?
  end

  test "aikotobaが欠如で無効" do
    family = Family.new(email: "test@test.com", aikotoba: "", password: "password123")
    assert_not family.valid?
  end

  test "passwordが欠如で無効" do
    family = Family.new(email: "test@test.com", aikotoba: "aaa", password: "")
    assert_not family.valid?
  end

  test "passwordの文字数が７文字で無効" do
    family = Family.new(email: "test@test.com", aikotoba: "aaa", password: "aaaaaaa")
    assert_not family.valid?
  end

  test "passwordの文字数が８文字以上で有効" do
    family = Family.new(email: "test@test.com", aikotoba: "aaa", password: "aaaaaaaa")
    assert family.valid?
  end
end
