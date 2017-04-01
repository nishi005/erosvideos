class FavoriteMovie < ActiveRecord::Base
	@LIMIT_RECORD_NUM = 40
	@row_num = 0

	validates :usr_name,
		presence: true,
		length: {maximum: 50}
	validates :favorite_movie_id,
		presence: true,
		numericality: {only_integer: true}

	def self.isRecord(usr_name, video_id)
		favorite_info = FavoriteMovie.find_by(usr_name: usr_name, favorite_movie_id: video_id)
		if favorite_info != nil then
			return true
		else
			return false
		end
	end

	def self.keepRecordNum(usr_name)
		@row_num = FavoriteMovie.where(usr_name: usr_name).count
		if @row_num <= @LIMIT_RECORD_NUM then
			return
		end
		@row_num -= @LIMIT_RECORD_NUM
		FavoriteMovie.where(usr_name: usr_name).limit(@row_num).destroy_all(usr_name: usr_name)
	end
end
