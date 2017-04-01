class AfterWatchMovie < ActiveRecord::Base

  @LIMIT_RECORD_NUM = 40
  @row_num = 0

  validates :usr_name,
    presence: true,
    length: {maximum: 50}
  validates :after_watch_movie_id,
    presence: true,
    numericality: {only_integer: true}

    def self.isRecord(usr_name, video_id)
      after_movie_info = AfterWatchMovie.find_by(usr_name: usr_name, after_watch_movie_id: video_id)
      if after_movie_info != nil then
        return true;
      else
        return false;
      end
    end

    def self.keepRecordNum(usr_name)
        @row_num = AfterWatchMovie.where(usr_name: usr_name).count;
        if @row_num <= 20 then
          return
        end
        @row_num -= @LIMIT_RECORD_NUM;
        AfterWatchMovie.where(usr_name: usr_name).limit(@row_num).destroy_all(usr_name: usr_name)
    end
end
