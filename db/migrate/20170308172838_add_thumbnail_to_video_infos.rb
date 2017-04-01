class AddThumbnailToVideoInfos < ActiveRecord::Migration
  def change
    add_column :video_infos, :thumbnail, :string
  end
end
