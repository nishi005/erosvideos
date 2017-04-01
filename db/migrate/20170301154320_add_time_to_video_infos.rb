class AddTimeToVideoInfos < ActiveRecord::Migration
  def change
    add_column :video_infos, :time, :time
  end
end
