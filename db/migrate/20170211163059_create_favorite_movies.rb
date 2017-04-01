class CreateFavoriteMovies < ActiveRecord::Migration
  def change
    create_table :favorite_movies do |t|
      t.string :usr_name
      t.integer :favorite_movie_id

      t.timestamps null: false
    end
  end
end
