class RetirementsController < ApplicationController
  def new
  end

  def create
    if current_user.destroy
      # ユーザーレコードの削除に成功したら、セッションを削除して一旦ログアウトした場合と同じ状態にします。
      reset_session
      redirect_to root_path, notice: '退会完了しました'
    end
  end
end
