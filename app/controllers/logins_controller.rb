class LoginsController < ApplicationController

def show
	flash[:referer] = request.headers['Referer']
end

def auth
	usr = User.authenticate(params[:username], params[:password])

	if usr then
		reset_session
		session[:usr] = usr.id
		redirect_to params[:referer]
	else
		flash.now[:referer] = params[:referer]
		@error_message = "ログインに失敗しました。IDかパスワードが間違っています。"
		render 'show'
	end
end

end
