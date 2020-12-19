require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test '#created_by?のowner_idとuserの引数の#idが一致するとき'do
  #   event = FactoryBot.create(:event)
  #   user = User.new
  #   # 新しいユーザーとイベントを関連付け
  #   user.stub(:id, event.owner_id) do
  #     # 成功するテストメソッド
  #     assert_equal(true, event.created_by?(user))
  #   end
  # end

  test '#created_by?のowner_idとuserの引数の#idが一致するとき'do
    event = FactoryBot.create(:event)
    user = MiniTest::Mock.new.expect(:id, event.owner_id)
    # 成功するテストメソッド
    assert_equal(true, event.created_by?(user))
    user.verify
  end


  test '#created_by?のowner_idとuserの引数の#idが異なるとき' do
    event = FactoryBot.create(:event)
    another_user = FactoryBot.create(:user)
    assert_equal(false, event.created_by?(another_user))
  end

  test '#created_by?の引数がnilのとき' do
    event = FactoryBot.create(:event)
    assert_equal(false, event.created_by?(nil))
  end


  # バリデーションテスト（成功する場合の）
  test 'start_at_should_be_before_end_at validation OK' do
    start_at = rand(1..30).days.from_now
    end_at = start_at + rand(1..30).hours

    event = FactoryBot.build(:event, start_at: start_at, end_at: end_at)

    # eventオブジェクトが有効かどうか
    event.valid?

    assert_empty(event.errors[:start_at])
  end


  # バリデーションテスト（バリデーションエラーが発生する場合）
  test 'start_at_should_be_before_end_at validation error' do
    start_at = rand(1..30).days.from_now
    end_at = start_at - rand(1..30).hours

    event = FactoryBot.build(:event, start_at: start_at, end_at: end_at)

    # eventオブジェクトが有効かどうか
    event.valid?

    assert_not_empty(event.errors[:start_at])
  end
end
