class LogoutsController < ApplicationController
  def show
  	reset_session
  	redirect_to request.headers['Referer']
  end
end
