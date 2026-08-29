require "test_helper"

class Families::SettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    @speaker = Speaker.create!(family: @family, name: "テスト太郎")
    post families_sessions_path, params: { family: { aikotoba: "aaa", password: "password123" } }
  end

  test "設定項目を役割と目的が分かる名称で表示する" do
    get families_settings_path

    assert_response :success
    assert_select "legend", "「こえ」が届いていないときのお知らせ"
    assert_select "legend", "「こえ」を届ける家族"
    assert_select "legend", "見守る家族のログイン情報"
    assert_select "a", "退会する"
    assert_select "a.link:not(.btn)", text: /今日の「こえ」に戻る/
    assert_no_match(/こえが届いたら画面で知らせる/, response.body)
    assert_no_match(/＋ 追加する/, response.body)
  end

  test "設定を更新すると画面上のお知らせを有効に保つ" do
    patch families_settings_path, params: { notify_at: "18:00", aikotoba: "newword", email: "new@example.com" }

    assert_redirected_to families_speakers_path
    assert @speaker.reload.notifications_enabled
    assert_equal "18:00", @speaker.notify_at.strftime("%H:%M")
    assert_equal "newword", @family.reload.aikotoba
  end

  test "他の家族と同じメールアドレスに変更しようとすると失敗し、元のメールアドレスのまま" do
    Family.create!(email: "taken@test.com", aikotoba: "ccc", password: "password123")
    family = Family.create!(email: "a@test.com", aikotoba: "bbb", password: "password123")
    post families_sessions_path, params: { family: { aikotoba: family.aikotoba, password: "password123" } }

    patch families_settings_path, params: { email: "taken@test.com", aikotoba: family.aikotoba }

    assert_response :unprocessable_entity
    family.reload
    assert_equal "a@test.com", family.email
  end
end
