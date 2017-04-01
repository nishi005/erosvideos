class VideosController < ApplicationController
  before_action :check_logined, only: [:index, :show]

  def index
    @LIST_NUM_INDEX = 12
    @new_video_infos = VideoInfo.all.limit(@LIST_NUM_INDEX).order(id: :desc)
    @popular_video_infos = VideoInfo.all.order(total_number_of_views: :desc).limit(@LIST_NUM_INDEX)
    render layout: 'outer'
  end

  def show
    @video_infos = VideoInfo.find_by(id: params[:id])
  	if @video_infos != nil then
  		@tag_infos = VideoTag.where(video_id: params[:id])

  		@video_infos.update(total_number_of_views: @video_infos.total_number_of_views + 1)

  		if @video_infos.video_type =~ /ThisAV/i
  			document = getHtmlDocument(@video_infos.video_id)
        begin
          @movie_addr = document.xpath('//source')[0].attribute('src').text
        rescue => e
          @movie_addr = nil
        end
  		end

  		if @usr != nil then
  			if History.isRecord(@usr.usr_name, params[:id]) == false then
  				@new_record = History.new(usr_name: @usr.usr_name, history_movie_id: params[:id])
  				@new_record.save
  				History.keepRecordNum(@usr.usr_name)
  			else
  				History.find_by(usr_name: @usr.usr_name, history_movie_id: params[:id]).update(updated_at: Time.now)
  			end
  		end

  		render layout: 'outer'
  	else
  		render text: '値が不正です。'
  	end
  end

  def bad
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

  def getHtmlDocument(url)
  	charset = nil
  	html = open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |file|
  		charset = file.charset
  		file.read
  	end

  	if charset == 'iso-8859-1' then
  		charset = 'utf-8'
  	end

  	return Nokogiri::HTML.parse(html, nil, charset)
  end

end
