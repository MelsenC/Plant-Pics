class AlterPicsAddUserId < ActiveRecord::Migration[5.0]
  def change
    add_column :pics, :user_id, :integer
    add_index :pics, :user_id
  end
end
