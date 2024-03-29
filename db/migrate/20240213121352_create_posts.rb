class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.integer :user_id, null: false
      t.integer :color_id, null: false

      t.timestamps
    end
  end
end
