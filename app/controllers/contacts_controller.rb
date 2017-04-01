class ContactsController < ApplicationController
  before_action :check_logined, only: [:show]

  def show
    render layout: 'outer'
  end

  def sendmail
  	@message = ""
  	if params[:inputEmail] == "" then
  		@message = "メールアドレスを入力してください。"
  	elsif params[:inputSubject] == "" then
  		@message = "題名を入力してください。"
  	elsif params[:inputMessage] == "" then
  		@message = "メッセージを入力してください。"
  	else
  		@mail = ContactMailer.sendmail_contact(params[:inputEmail], params[:inputSubject], params[:inputMessage]).deliver
  		@message = "メールの送信が完了しました。"
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
