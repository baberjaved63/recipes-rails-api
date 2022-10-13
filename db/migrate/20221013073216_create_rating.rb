class CreateRating < ActiveRecord::Migration[7.0]
  def change
    create_table :ratings do |t|
      t.belongs_to :recipe
      t.belongs_to :user
      t.integer :rate
      t.timestamps
    end

    add_index :ratings, [:recipe_id, :user_id], unique: true
  end
end
