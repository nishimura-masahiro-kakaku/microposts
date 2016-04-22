class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :user, index: true
      t.references :post, index: true

      t.timestamps null: false

      t.index [:user_id, :post_id], unique: true
    end
  end
end
