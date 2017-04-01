class UsersController < ApplicationController
  def create
    params = user_params
    if params[:user_password] == '' then
      params[:user_password] = nil
    else
      params[:user_password] = Digest::SHA1.hexdigest(params[:user_password])
      params[:user_password_confirmation] = Digest::SHA1.hexdigest(params[:user_password_confirmation])
    end

    @new_user_info = User.new(params)
  	begin
  		if @new_user_info.save! then
        return
  		end
  	rescue ActiveRecord::RecordInvalid => e
  		case e.message
  		when "Validation failed: Usr name has already been taken"
  			flash['error_message'] = "既に使用されているIDです。IDを変えて登録してください。"
  		when "Validation failed: User password confirmation doesn't match User password"
  			flash['error_message'] = "確認用パスワードに誤りがあります。もう一度やり直してください。"
  		when "Validation failed: Usr name has already been taken, User password confirmation doesn't match User password"
  			flash['error_message'] = "既に使用済みのIDかつ、確認用のパスワードに誤りがあります。もう一度やり直してください。"
  		when "Validation failed: Usr name can't be blank"
  			flash['error_message'] = "IDを入力してください。"
  		when "Validation failed: User password can't be blank"
  			flash['error_message'] = "パスワードを入力してください。"
  		else
        puts e.message
  			flash['error_message'] = "ユーザ名とパスワードは必須です。パスワードは確認用のパスワードと一致している必要があります。既に使用されているユーザ名は使用できません。"
  		end
  	end
    redirect_to signup_path
  end

  private

  def user_params
    params.require(:user).permit(:usr_name, :user_password, :user_password_confirmation)
  end
end
