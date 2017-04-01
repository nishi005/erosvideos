class HighlyRatedVideosController < ApplicationController
  before_action :check_logined, only: [:index, :show, :create]

  def initialize
    @LIST_NUM_HIGHLY_RATED = 12
  end

  def index
    if @usr != nil then
  		@page_num = 0

  		@highly_rated_movies = HighlyRatedMovie.where(usr_name: @usr.usr_name).limit(@LIST_NUM_HIGHLY_RATED).offset(@LIST_NUM_HIGHLY_RATED * @page_num).order(id: :desc)
  		@total_of_results = HighlyRatedMovie.where(usr_name: @usr.usr_name).count
  		@pagenation_num = (@total_of_results / (@LIST_NUM_HIGHLY_RATED * 1.0)).ceil
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
  		@highly_rated_movies = HighlyRatedMovie.where(usr_name: @usr.usr_name).limit(@LIST_NUM_HIGHLY_RATED).offset(@LIST_NUM_HIGHLY_RATED * @page_num).order(id: :desc)
  		@total_of_results = HighlyRatedMovie.where(usr_name: @usr.usr_name).count
  		@pagenation_num = (@total_of_results / (@LIST_NUM_HIGHLY_RATED * 1.0)).ceil
  	end
  	render layout: 'outer'
  end

  def create
    @message = ""
  	if @usr != nil then
      begin
        if HighlyRatedMovie.isRecord(@usr.usr_name, params[:id]) == true then
    			HighlyRatedMovie.find_by(usr_name: @usr.usr_name, highly_rated_movie_id: params[:id]).destroy
    			VideoInfo.setGood(params[:id], -1)
    			@message = "高評価を取り消しました"
    		else
    			@new_record = HighlyRatedMovie.new(usr_name: @usr.usr_name, highly_rated_movie_id: params[:id])
    			@new_record.save
    			VideoInfo.setGood(params[:id], 1)
    			HighlyRatedMovie.keepRecordNum(@usr.usr_name)
    			@message = "この動画を高評価しました"
    		end
      rescue => e
        @message = e.message
      end
  	else
  		@message = "ログインしてください"
  	end
  	@good_num = VideoInfo.getGood(params[:id])
  end

  def destroy
    @usr_name = User.find_by(id: session[:usr]).usr_name
  	HighlyRatedMovie.destroy_all(usr_name: @usr_name, highly_rated_movie_id: params[:id])
  	VideoInfo.setGood(params[:id], -1)
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
