class DislikedVideosController < ApplicationController
  before_action :check_logined, only:[:update]

  def update
  	@message = ""
  	if @usr != nil then
  		if PoorlyRatedMovie.isRecord(@usr.usr_name, params[:id]) == true then
  			PoorlyRatedMovie.find_by(usr_name: @usr.usr_name, poorly_rated_movie_id: params[:id]).destroy
  			VideoInfo.setBad(params[:id], -1)
  			@message = "低評価を取り消しました"
  		else
  			@new_record = PoorlyRatedMovie.new(usr_name: @usr.usr_name, poorly_rated_movie_id: params[:id])
  			@new_record.save
  			VideoInfo.setBad(params[:id], 1)
  			@message = "この動画を低評価しました"
  		end
  	else
  		@message = "ログインしてください"
  	end
  	@bad_num = VideoInfo.getBad(params[:id])
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
