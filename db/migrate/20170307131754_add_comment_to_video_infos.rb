class AddCommentToVideoInfos < ActiveRecord::Migration
  def change
    add_column :video_infos, :comment, :string
  end
end
