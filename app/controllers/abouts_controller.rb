class AboutsController < ApplicationController
  before_action :check_logined, only: [:show]

  def show
    render layout: 'outer'
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
