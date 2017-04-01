class AllVideosController < ApplicationController
  before_action :check_logined, only: [:show]

  def show
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
  	@LIST_NUM_ALL = 12
  	if params[:order] == 'new' then
  		@all_videos = VideoInfo.all.limit(@LIST_NUM_ALL).offset(@LIST_NUM_ALL * @page_num).order(id: :desc)
  		@pagenation_num = (VideoInfo.all.count / (@LIST_NUM_ALL * 1.0)).ceil
  	elsif params[:order] == 'popular' then
  		@all_videos = VideoInfo.all.limit(@LIST_NUM_ALL).offset(@LIST_NUM_ALL * @page_num).order(total_number_of_views: :desc)
  		@pagenation_num = (VideoInfo.all.count / (@LIST_NUM_ALL * 1.0)).ceil
  	end
  	render layout: 'outer'
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
