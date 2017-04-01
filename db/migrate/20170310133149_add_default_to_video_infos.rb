class AddDefaultToVideoInfos < ActiveRecord::Migration
  def change
    change_column_default :video_infos, :total_number_of_views, 0
    change_column_default :video_infos, :good, 0
    change_column_default :video_infos, :bad, 0
  end
end
