class FavoritesController < ApplicationController
  before_action :check_logined, only: [:index, :show, :create]

  def initialize
    @LIST_NUM_FAVORITE = 12
  end

  def index
    if @usr != nil then
  		@page_num = 0

  		@favorite_movies = FavoriteMovie.where(usr_name: @usr.usr_name).limit(@LIST_NUM_FAVORITE).offset(@LIST_NUM_FAVORITE * @page_num).order(id: :desc)
  		@total_of_results = FavoriteMovie.where(usr_name: @usr.usr_name).count
  		@pagenation_num = (@total_of_results / (@LIST_NUM_FAVORITE * 1.0)).ceil
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
  		@favorite_movies = FavoriteMovie.where(usr_name: @usr.usr_name).limit(@LIST_NUM_FAVORITE).offset(@LIST_NUM_FAVORITE * @page_num).order(id: :desc)
  		@total_of_results = FavoriteMovie.where(usr_name: @usr.usr_name).count
  		@pagenation_num = (@total_of_results / (@LIST_NUM_FAVORITE * 1.0)).ceil
  	end
  	render layout: 'outer'
  end

  def create
    @message = "";
  	if @usr != nil then
      begin
        if FavoriteMovie.isRecord(@usr.usr_name, params[:id]) == false then
    			@new_record = FavoriteMovie.new(usr_name: @usr.usr_name, favorite_movie_id: params[:id])
    			@new_record.save
    			FavoriteMovie.keepRecordNum(@usr.usr_name)
    			@message = "お気に入り登録完了しました"
    		else
    			@message = "既にお気に入りに入っています"
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
    FavoriteMovie.destroy_all(usr_name: @usr_name, favorite_movie_id: params[:id])
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
