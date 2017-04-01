class HighlyRatedMovie < ActiveRecord::Base

  @LIMIT_RECORD_NUM = 40
  @row_num = 0

  validates :usr_name,
    presence: true,
    length: {maximum: 50}
  validates :highly_rated_movie_id,
    presence: true,
    numericality: {only_integer: true}

  def self.isRecord(usr_name, video_id)
    highly_rated_movie = HighlyRatedMovie.find_by(usr_name: usr_name, highly_rated_movie_id: video_id)
    if highly_rated_movie != nil then
      return true
    else
      return false
    end
  end

  def self.keepRecordNum(usr_name)
    @row_num = HighlyRatedMovie.where(usr_name: usr_name).count
    if @row_num <= 20 then
      return
    else
      @row_num -= @LIMIT_RECORD_NUM;
      HighlyRatedMovie.where(usr_name: usr_name).limit(@row_num).destroy_all(usr_name: usr_name)
    end
  end
end
