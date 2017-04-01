class WatchLaterController < ApplicationController
  before_action :check_logined, only: [:index, :show, :create]

  def initialize
		@LIST_NUM_AFTER_WATCH = 12
  end

  def index
    if @usr != nil then
  		@page_num = 0

  		@after_watch_movies = AfterWatchMovie.where(usr_name: @usr.usr_name).limit(@LIST_NUM_AFTER_WATCH).offset(@LIST_NUM_AFTER_WATCH * @page_num).order(id: :desc)
  		@total_of_results = AfterWatchMovie.where(usr_name: @usr.usr_name).count
  		@pagenation_num = (@total_of_results / (@LIST_NUM_AFTER_WATCH * 1.0)).ceil
  	end
  	render layout: 'outer'
  end

  def show
    if @usr != nil then
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
  		@after_watch_movies = AfterWatchMovie.where(usr_name: @usr.usr_name).limit(@LIST_NUM_AFTER_WATCH).offset(@LIST_NUM_AFTER_WATCH * @page_num).order(id: :desc)
  		@total_of_results = AfterWatchMovie.where(usr_name: @usr.usr_name).count
  		@pagenation_num = (@total_of_results / (@LIST_NUM_AFTER_WATCH * 1.0)).ceil
  	end
  	render layout: 'outer'
  end

  def create
    @message = ""
  	if @usr != nil then
      begin
        if AfterWatchMovie.isRecord(@usr.usr_name, params[:id]) == false then
    			@new_record = AfterWatchMovie.new(usr_name: @usr.usr_name, after_watch_movie_id: params[:id])
    			@new_record.save
    			AfterWatchMovie.keepRecordNum(@usr.usr_name)
    			@message = "後で見るに追加しました"
    		else
    			@message = "既に後で見るに入っています"
    		end
      rescue => e
        @message = e.message
      end
  	else
  		@message = "ログインしてください"
  	end
  end

  def destroy
    @usr_name = User.find_by(id: session[:usr]).usr_name
    AfterWatchMovie.destroy_all(usr_name: @usr_name, after_watch_movie_id: params[:id])
  end

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
