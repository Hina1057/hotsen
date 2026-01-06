class HotelsController < ApplicationController
  def index
    @area = params[:area].to_s.strip
    @check_in_on = params[:check_in_on].to_s
    @stay_count = (params[:stay_count].presence || 1).to_i
    @guest_count = (params[:guest_count].presence || 1).to_i

    # 入力チェック（UC3）
    errors = []

    errors << "エリアを選択してください" if @area.blank?
    errors << "チェックイン日を入力してください" if @check_in_on.blank?

    if @check_in_on.present?
      begin
        check_in = Date.parse(@check_in_on)
        errors << "チェックイン日に過去の日付は指定できません" if check_in < Date.current
      rescue ArgumentError
        errors << "チェックイン日が正しくありません"
      end
    end

    errors << "宿泊数は1以上を入力してください" if @stay_count < 1
    errors << "人数は1以上を入力してください" if @guest_count < 1

    if errors.any?
      flash.now[:alert] = errors.join(" / ")
      @hotels = []
      @informations = Information.order(created_at: :desc).limit(5)
      render "top/index", status: :unprocessable_entity and return
    end

    # 検索（まずはエリア一致でOK。LIKEにしたいなら残してもいい）
    scope = Hotel.where(area: @area)
    @hotels = scope.order(:id)

    @searched = true
  end

  def show
    @hotel = Hotel.find(params[:id])
    @rooms = @hotel.rooms.order(:id)
  end
end