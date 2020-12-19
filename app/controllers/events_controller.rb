class EventsController < ApplicationController
  # イベントの情報はログインしてるしてないにかかわらず見れるようにする
  skip_before_action :authenticate, only: :show
  def new
    # ユーザーがログインしていることが前提なのでcurrent_user
    @event = current_user.created_events.build
  end

  def create
    @event = current_user.created_events.build(event_params)

    if @event.save
      redirect_to @event, notice: '作成しました'
    end
  end

  def show
    @event = Event.find(params[:id])
    # trueだったら@ticketにtrueが格納されるのか？？？ 具体的なticketのオブジェクトが格納されるのか？？
    @ticket = current_user && current_user.tickets.find_by(event: @event)
    p @ticket
    @tickets = @event.tickets.includes(:user).order(:created_at)
  end

  def edit
    # ユーザがログインユーザーであるという前提が必要
    @event = current_user.created_events.find(params[:id])
  end

  def update
    @event = current_user.created_events.find(params[:id])
    if @event.update(event_params)
      # 同期的に同じページを表示する
      redirect_to @event, notice: '更新しました'
    end
  end


  def destroy
    @event = current_user.created_events.find(params[:id])
    @event.destroy!
    redirect_to root_path, notice: '削除しました'
  end

  private

  def event_params
    params.require(:event).permit(
      :name, :place, :image, :remove_image, :content, :start_at, :end_at
    )
  end
end
