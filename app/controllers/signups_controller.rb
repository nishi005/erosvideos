class SignupsController < ApplicationController
  def show
    @user = User.new
  end
end
