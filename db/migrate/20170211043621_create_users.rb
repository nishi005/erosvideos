class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :usr_name
      t.string :user_password

      t.timestamps null: false
    end
  end
end
