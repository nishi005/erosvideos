class CreateHighlyRatedMovies < ActiveRecord::Migration
  def change
    create_table :highly_rated_movies do |t|
      t.string :usr_name
      t.integer :highly_rated_movie_id

      t.timestamps null: false
    end
  end
end
