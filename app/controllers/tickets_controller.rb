class TicketsController < ApplicationController
  def new
    # ActionControllerでのbefore_actionのauthenticateによるトップページへの遷移を期待（エラーが発生するのはそこで何かしらのせいでトップページ遷移できなかった場合）
    raise ActionController::RoutingError, 'ログイン状態で TicketController#newにアクセス'
  end

  def create
    event = Event.find(params[:event_id])
    @ticket = current_user.tickets.build do |t|
      t.event = event
      t.comment = params[:ticket][:comment]
    end

    if @ticket.save
      redirect_to event, notice: 'このイベントに参加しました'
    end
  end

  def destroy
    # activerecordで「!」がつくメソッドは、異常が発見された場合にキチンと例外を発生させることができる
    ticket = current_user.tickets.find_by!(event_id: params[:event_id])
    ticket.destroy!
    redirect_to event_path(params[:event_id]), notice: 'このイベントへの参加をキャンセルしました'
  end
end
