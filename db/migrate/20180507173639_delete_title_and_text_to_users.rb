class DeleteTitleAndTextToUsers < ActiveRecord::Migration[5.2]
  def self.up
    remove_column :users, :title
    remove_column :users, :text
  end
  def self.down
    add_column :users, :title
    add_column :users, :text
  end
end
