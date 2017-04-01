class CreateVideoInfos < ActiveRecord::Migration
  def change
    create_table :video_infos do |t|
      t.string :video_id
      t.string :title
      t.string :video_type
      t.integer :total_number_of_views
      t.integer :good
      t.integer :bad

      t.timestamps null: false
    end
  end
end
