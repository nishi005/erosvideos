require 'test_helper'

class VideoInfoTest < ActiveSupport::TestCase
  test "video_info save" do

    video_info = VideoInfo.new({
      id: 179,
      video_id: 'xvideos004',
      title: 'japanese tits',
      video_type: 'xvideos',
      total_number_of_views: 0,
      good: 0,
      bad: 0
    })

    assert !video_info.save, 'faild to validate'
  end
end
