require "test_helper"

class Families::SpeakersControllerTest < ActionDispatch::IntegrationTest
  test "今日の「こえ」に最終録音情報を表示する" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    speaker = Speaker.create!(family: family, name: "テスト太郎")
    theme = Theme.create!(title: "今日の気分")
    post_record = speaker.posts.create!(theme: theme, created_at: Time.zone.now, audio: { io: File.open(Rails.root.join("test/fixtures/files/test_audio.webm")), filename: "test_audio.webm", content_type: "audio/webm" })
    post families_sessions_path, params: { family: { aikotoba: "aaa", password: "password123" } }

    get families_speakers_path

    assert_response :success
    assert_select "h1", "今日の「こえ」"
    assert_select "h2 a[href='#{families_speaker_posts_path(speaker)}']", "テスト太郎"
    assert_select "h2 span[class*='text-base-content/50']", "最後の投稿から1時間未満"
    assert_select "a[href='#{families_speaker_posts_path(speaker)}']", text: /テスト太郎さんの「こえ」の\s*一覧へ/
    assert_match(/「今日の気分」の\s*「こえ」が届きました。/, response.body)
    assert_select "button[aria-label='再生']"
    assert_select "input[type='range'][aria-label='再生位置']"
    assert_select "audio"
    assert_select "a", text: /更新する（\d{2}:\d{2}）/
    assert_select "a", text: /見守りたい家族を追加/
    assert_no_match(/誰かが聞きました|今日まだ誰も聞いていません/, response.body)
  end

  test "人名の右に最後の投稿からの経過時間を表示する" do
    travel_to Time.zone.local(2026, 8, 28, 17, 52, 0) do
      family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
      speaker = Speaker.create!(family: family, name: "テスト太郎")
      speaker.posts.create!(created_at: 5.hours.ago, audio: { io: File.open(Rails.root.join("test/fixtures/files/test_audio.webm")), filename: "test_audio.webm", content_type: "audio/webm" })
      post families_sessions_path, params: { family: { aikotoba: "aaa", password: "password123" } }

      get families_speakers_path

      assert_response :success
      assert_select "h2 span", "最後の投稿から5時間経過"
    end
  end

  test "最後の投稿から30時間以上経過したら赤字で表示する" do
    travel_to Time.zone.local(2026, 8, 28, 17, 52, 0) do
      family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
      speaker = Speaker.create!(family: family, name: "テスト太郎")
      speaker.posts.create!(created_at: 30.hours.ago, audio: { io: File.open(Rails.root.join("test/fixtures/files/test_audio.webm")), filename: "test_audio.webm", content_type: "audio/webm" })
      post families_sessions_path, params: { family: { aikotoba: "aaa", password: "password123" } }

      get families_speakers_path

      assert_response :success
      assert_select "h2 span.text-error", "最後の投稿から30時間経過"
    end
  end

  test "録音がない家族には未着通知ではなく録音準備へのリンクを表示する" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    speaker = Speaker.create!(family: family, name: "テスト太郎", notify_at: "00:00")
    post families_sessions_path, params: { family: { aikotoba: "aaa", password: "password123" } }

    get families_speakers_path

    assert_response :success
    assert_select "h2 a[href='#{families_speaker_posts_path(speaker)}']", "テスト太郎"
    assert_select "li.card > .bg-warning", text: "まだ「こえ」は登録されていません。"
    assert_select "div[class*='bg-warning/15']" do
      assert_select "svg"
      assert_select "a.btn[href='#{families_speaker_path(speaker)}']", text: /録音の準備方法を\s*開始する/
    end
    assert_select "p", text: "テスト太郎さんのスマートフォンで録音の準備を始めましょう。"
    assert_select ".bg-error", text: "今日の「こえ」がまだ届いていません。", count: 0
  end

  test "設定時刻を過ぎても今日のこえがなければカードヘッダーで知らせる" do
    travel_to Time.zone.local(2026, 8, 28, 12, 0, 0) do
      family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
      speaker = Speaker.create!(family: family, name: "テスト太郎", notify_at: "10:00")
      speaker.posts.create!(created_at: 1.day.ago, audio: { io: File.open(Rails.root.join("test/fixtures/files/test_audio.webm")), filename: "test_audio.webm", content_type: "audio/webm" })
      post families_sessions_path, params: { family: { aikotoba: "aaa", password: "password123" } }

      get families_speakers_path

      assert_response :success
      assert_select "li.card > .bg-error", text: "今日の「こえ」がまだ届いていません。"
    end
  end

  test "有効な名前の家族（Speaker）を追加する" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    post families_sessions_path, params: { family: { aikotoba: "aaa", password: "password123" } }
    post families_speakers_path, params: { speaker: { name: "テスト太郎" } }
    assert_redirected_to families_speaker_path(Speaker.last)
  end

  test "無効な名前の家族（Speaker）の追加に失敗する" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    post families_sessions_path, params: { family: { aikotoba: "aaa", password: "password123" } }
    post families_speakers_path, params: { speaker: { name: nil } }
    assert_response :unprocessable_entity
  end

  test "受け取り停止にするとactiveがfalseになり、データは残る" do
    family = Family.create!(email: "test@test.com", aikotoba: "aaa", password: "password123")
    speaker = Speaker.create!(family: family, name: "テスト太郎")
    post_record = speaker.posts.create!(audio: fixture_file_upload("test_audio.webm", "audio/webm"))

    post families_sessions_path, params: { family: { aikotoba: "aaa", password: "password123" } }
    patch deactivate_families_speaker_path(speaker)

    assert_redirected_to families_speakers_path
    assert_not speaker.reload.active
    assert Speaker.exists?(speaker.id)
    assert Post.exists?(post_record.id)
  end
end
