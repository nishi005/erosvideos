class PoorlyRatedMovie < ActiveRecord::Base
  validates :usr_name,
    presence: true,
    length: {maximum: 50}
  validates :poorly_rated_movie_id,
    presence: true,
    numericality: {only_integer: true}

  def self.isRecord(usr_name, video_id)
    poorly_rated_movie = PoorlyRatedMovie.find_by(usr_name: usr_name, poorly_rated_movie_id: video_id)
    if poorly_rated_movie != nil then
      return true
    else
      return false
    end
  end
end
