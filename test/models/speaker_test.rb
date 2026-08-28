require "test_helper"

class SpeakerTest < ActiveSupport::TestCase
  test "notifications_enableがfalseなら、notifications_needed?はfalse" do
    speaker = Speaker.new(family: families(:one), name: "テスト", notifications_enabled: false, active: true, notify_at: Time.current)
    assert_not speaker.notifications_needed?
  end

  test "activeがfalseなら、notifications_needed?はfalse" do
    speaker = Speaker.new(family: families(:one), name: "テスト", notifications_enabled: true, active: false, notify_at: Time.current)
    assert_not speaker.notifications_needed?
  end

  test "今日すでに投稿しているなら、notifications_needed?はfalseを返して終了する" do
    speaker = Speaker.create(family: families(:one), name: "テスト", notifications_enabled: true, active: true, notify_at: Time.current)
    speaker.posts.create!(created_at: Time.current)
    assert_not speaker.notifications_needed?
  end

  test "通知時刻より前なら、notifications_needed?はfalse" do
    travel_to Time.zone.local(2026, 8, 1, 10, 0, 0) do
      speaker = Speaker.create(family: families(:one), name: "テスト", notifications_enabled: true, active: true, notify_at: Time.zone.local(2026, 8, 1, 12, 0, 0))
      assert_not speaker.notifications_needed?
    end
  end

  test "通知時刻より後なら、notifications_needed?はtrue" do
    travel_to Time.zone.local(2026, 8, 1, 10, 0, 0) do
      speaker = Speaker.create(family: families(:one), name: "テスト", notifications_enabled: true, active: true, notify_at: Time.zone.local(2026, 8, 1, 8, 0, 0))
      assert speaker.notifications_needed?
    end
  end

end
