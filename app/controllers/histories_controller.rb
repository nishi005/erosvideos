class HistoriesController < ApplicationController
  before_action :check_logined, only: [:index, :show]

  def initialize
	   @LIST_NUM_HISTORY = 12
  end

  def index
    if @usr != nil then
  		@page_num = 0

  		@histories = History.where(usr_name: @usr.usr_name).limit(@LIST_NUM_HISTORY).offset(@LIST_NUM_HISTORY * @page_num).order(updated_at: :desc)
  		@total_of_results = History.where(usr_name: @usr.usr_name).count
  		@pagenation_num = (@total_of_results / (@LIST_NUM_HISTORY * 1.0)).ceil
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
  		@histories = History.where(usr_name: @usr.usr_name).limit(@LIST_NUM_HISTORY).offset(@LIST_NUM_HISTORY * @page_num).order(updated_at: :desc)
  		@total_of_results = History.where(usr_name: @usr.usr_name).count
  		@pagenation_num = (@total_of_results / (@LIST_NUM_HISTORY * 1.0)).ceil
  	end
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
