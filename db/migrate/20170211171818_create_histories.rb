class CreateHistories < ActiveRecord::Migration
  def change
    create_table :histories do |t|
      t.string :usr_name
      t.integer :history_movie_id

      t.timestamps null: false
    end
  end
end
