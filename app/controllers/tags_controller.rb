class TagsController < ApplicationController
  before_action :check_logined, only: [:index]

  def initialize
  	@LIST_NUM_TAG = 12
  end

  def index
    @page_num = params[:jump_page_num].nil? ? params[:id].to_i : params[:jump_page_num].to_i - 1
  	case params[:max_range]
  	when nil
  		#何もしない
  	else
  		if @page_num < 0 then
  			@page_num = 0
  		elsif @page_num > params[:max_range].to_i - 1
  			@page_num = params[:max_range].to_i - 1
  		end
  	end

    @search_query = ""

    #クエリの生成
    @sortingOption = params[:sortingOption].nil? ? 'update_day' : params[:sortingOption]
    @videoType = params[:videoType].nil? ? 'all' : params[:videoType]
    @uploadPeriod = params[:uploadPeriod].nil? ? 'all' : params[:uploadPeriod]
    @inputMovieLengthMin = params[:inputMovieLengthMin].nil? ? 'all' : params[:inputMovieLengthMin]
    @inputMovieLengthMax = params[:inputMovieLengthMax].nil? ? 'all' : params[:inputMovieLengthMax]

    case @sortingOption
    when 'update_day'
      order_option = 'id desc'
    when 'number_of_views'
      order_option = 'total_number_of_views desc'
    when 'movie_rate'
      order_option = 'good desc'
    end

    case @videoType
    when 'xvideos'
      @search_query << " and video_type = 'xvideos'"
    when 'pornhub'
      @search_query << " and (video_type = 'pornhub' or video_type = 'PornHub')"
    when 'tokyotube'
      @search_query << " and video_type = 'tokyotube'"
    when 'erovideo'
      @search_query << " and video_type = 'erovideo'"
    when 'sharemovie'
      @search_query << " and (video_type = 'sharemovie' or video_type = 'SHARE MOVIE')"
    when 'ThisAV'
      @search_query << " and video_type = 'ThisAV'"
    end

    today = Date.today
    case @uploadPeriod
    when 'today'
      @search_query << " and created_at > '#{today}'"
    when 'week'
      prev_week = today - 7
      @search_query << " and created_at > '#{Date.new(prev_week.year, prev_week.month, prev_week.day)}'"
    when 'month'
      prev_month = today << 1
      @search_query << " and created_at > '#{Date.new(prev_month.year, prev_month.month, prev_month.day)}'"
    when 'year'
      prev_year = today.year - 1
      @search_query << " and created_at > '#{Date.new(prev_year, today.month, today.day)}'"
    end

    begin
      min = Integer(@inputMovieLengthMin)
      max = Integer(@inputMovieLengthMax)

      hourMin = min / 60
      minuteMin = min % 60

      hourMax = max / 60
      minuteMax = max % 60

      minTime = Time.local(2001, 1, 1, hourMin, minuteMin, 0)
      maxTime = Time.local(2001, 1, 1, hourMax, minuteMax, 0)

      @search_query << " and time > '#{minTime.strftime('%H:%M:%S')}' and time < '#{maxTime.strftime('%H:%M:%S')}'"

    rescue ArgumentError => e
      #何もしない
    end

    @video_infos = VideoInfo.where("id in (select video_id from video_tags where tag = '#{params[:tag_name]}') #{@search_query} ").limit(@LIST_NUM_TAG).offset(@LIST_NUM_TAG * @page_num).order(order_option)
    @total_of_results = VideoInfo.where("id in (select video_id from video_tags where tag = '#{params[:tag_name]}') #{@search_query} ").count
    @pagenation_num = (@total_of_results / (@LIST_NUM_TAG * 1.0)).ceil
  	render layout: 'outer'
  end

  def create
		@message = ""
		@record_limit = 15
		@tag_info = nil
		if VideoTag.isRecord(params[:id], params[:added_tag]) == false then
			if VideoTag.isReachToLimit(params[:id], @record_limit) == false then
				@tag_info = VideoTag.new(video_id: params[:id], tag: params[:added_tag])
				@tag_info.save
				@message = "タグを追加しました。"
			else
				@message = "タグ数が上限に達しています。他のタグを削除してください。"
			end
		else
			@message = "既に登録済みのタグです。"
		end
  end

  def destroy
    referer_check = request.headers['Referer'].split('/')[4] == params[:id]
    case referer_check
    when true
      if VideoTag.isRecord(params[:id], params[:deleted_tag]) then
        VideoTag.find_by(video_id: params[:id], tag: params[:deleted_tag]).destroy
      end
    end
  end

  private

  def check_logined
    if session[:usr] then
      begin
        @usr = User.find(session[:usr])
        return @usr
      rescue ActiveRecord::RecordNotFound
        reset_session
      end
    else
      @usr = nil
      return @usr
    end
  end
end
