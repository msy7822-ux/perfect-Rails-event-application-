class WelcomeController < ApplicationController
  skip_before_action :authenticate

  def index
    @event_search_form = EventSearchForm.new(event_search_form_params)
    @events = @event_search_form.search
    # # まだ開始していないイベントに限定してデータを取得する（kaminariによるページネーション込）
    # @events = Event.page(params[:page]).per(5).where("start_at > ?", Time.zone.now).order(:start_at)
  end


  private

  def event_search_form_params
    # ページネーションを含めて考えるためにpageをmergeする
    params.fetch(:event_search_form, {}).permit(:keyword, :start_at).merge(page: params[:page])
  end
end
