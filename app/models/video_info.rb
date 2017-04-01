class VideoInfo < ActiveRecord::Base
  validates :video_id,
    presence: true,
    length: {maximum: 2000}
  validates :title,
    presence: true,
    length: {maximum: 200}
  validates :video_type,
    presence: true,
    length: {maximum: 20}
  validates :total_number_of_views,
    presence: true,
    numericality: {only_integer: true}
  validates :good,
    presence: true,
    numericality: {only_integer: true}
  validates :bad,
    presence: true,
    numericality: {only_integer: true}

  def self.setTotalNumberOfViews(video_id, add_num)
    if add_num >= 2 || add_num <= -2 then
      return
    end
    video_info = VideoInfo.find_by(id: video_id)
    video_info.update(total_number_of_views: video_info.total_number_of_views + add_num)
  end

  def self.getRecord(video_id)
      return VideoInfo.find_by(id: video_id)
  end

  def self.setGood(video_id, add_num)
    if add_num >= 2 || add_num <= -2 then
      return
    end
    video_info = VideoInfo.find_by(id: video_id)
    video_info.update(good: video_info.good + add_num)
  end

  def self.setBad(video_id, add_num)
    if add_num >= 2 || add_num <= -2 then
      return
    end
    video_info = VideoInfo.find_by(id: video_id)
    video_info.update(bad: video_info.bad + add_num)
  end

  def self.getGood(video_id)
    return VideoInfo.find_by(id: video_id).good
  end

  def self.getBad(video_id)
    return VideoInfo.find_by(id: video_id).bad
  end
end
