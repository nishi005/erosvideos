class CreatePoorlyRatedMovies < ActiveRecord::Migration
  def change
    create_table :poorly_rated_movies do |t|
      t.string :usr_name
      t.integer :poorly_rated_movie_id

      t.timestamps null: false
    end
  end
end
