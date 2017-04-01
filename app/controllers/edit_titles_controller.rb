class EditTitlesController < ApplicationController
  before_action :check_logined, only: [:show]

  def show
    method = request.request_method
    case method
    when 'GET'
      @video_info = VideoInfo.find_by(id: params[:video_id])
      render layout: 'outer'
    when 'POST'
      referer_check = request.headers['Referer'].split('/')[4] == params[:video_id]
    	case referer_check
    	when true
    		@message = "タイトルが変更されました。"
    		@video_info = VideoInfo.find_by(id: params[:video_id])
    		begin
    			@video_info.update!(title: params[:new_title])
    		rescue ActiveRecord::RecordInvalid => e
    			case e.message
    			when 'Validation failed: Title is too long (maximum is 60 characters)'
    				@message = "タイトルが長すぎます。60文字以内にしてください。"
    			when "Validation failed: Title can't be blank"
    				@message = "最低でも一文字は入力してください。"
    			end
    		end
    	when false
    		@message = "不正操作です。"
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
