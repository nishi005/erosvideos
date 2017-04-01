class CreateAfterWatchMovies < ActiveRecord::Migration
  def change
    create_table :after_watch_movies do |t|
      t.string :usr_name
      t.integer :after_watch_movie_id

      t.timestamps null: false
    end
  end
end
