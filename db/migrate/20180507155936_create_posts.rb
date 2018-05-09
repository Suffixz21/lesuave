class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :like
      t.string :title
      t.text :text
      # t.comments :comments
      t.references :pictures, polymorphic: true, index: true

      t.timestamps
    end
  end
end
