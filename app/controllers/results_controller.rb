class ResultsController < ApplicationController
before_action :check_logined, only: [:show]

def show
	if params[:keywd] == nil then
		redirect_to controller: :video_infos, action: :index
	else
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
		@LIST_NUM = params[:list_num].to_i * 1.0
		#クエリの生成
		@keywords = params[:keywd].split('　')
		@search_query = ""
		@keywords.each_with_index do |keyword, index|
			@search_query << "title like '%#{keyword}%'"
			if @keywords.size - 1 != index then
				@search_query << " and "
			end
		end

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
			@search_query << " and video_type = 'pornhub' or video_type = 'PornHub'"
		when 'tokyotube'
			@search_query << " and video_type = 'tokyotube'"
		when 'erovideo'
			@search_query << " and video_type = 'erovideo'"
		when 'sharemovie'
			@search_query << " and video_type = 'sharemovie' or video_type = 'SHARE MOVIE'"
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

		@results = VideoInfo.where(@search_query).limit(@LIST_NUM).offset(@LIST_NUM * @page_num).order(order_option)
		registerTags
		@total_of_results = VideoInfo.where(@search_query).count
		@pagenation_num = (@total_of_results / @LIST_NUM).ceil
		render layout: 'outer'
	end
end

def registerTags
	record_limit = 15
	@results.each do |result|
		@keywords.each do |keyword|
			if VideoTag.isRecord(result.id, keyword) == false then
				if VideoTag.isReachToLimit(result.id, record_limit) == false then
					tag_info = VideoTag.new(video_id: result.id, tag: keyword)
					tag_info.save
				end
			end
		end
	end
end

private

def check_logined
	if session[:usr] then
		@usr = User.find_by(id: session[:usr])
	else
		@usr = nil
	end
end

end
