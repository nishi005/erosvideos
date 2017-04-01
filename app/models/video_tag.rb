class VideoTag < ActiveRecord::Base
  validates :video_id,
    presence: true,
    numericality: {only_integer: true}
  validates :tag,
    presence: true,
    length: {maximum: 30}

  def self.isRecord(video_id, tag)
    tag_info = VideoTag.find_by(video_id: video_id, tag: tag)
    if tag_info != nil then
      return true
    else
      return false
    end
  end

  def self.isReachToLimit(video_id, limit_num)
    @row_num = VideoTag.where(video_id: video_id).count
    if @row_num < limit_num then
      return false
    else
      return true
    end
  end
end
