class CreatePics < ActiveRecord::Migration[5.0]
  def change
    create_table :pics do |t|
      t.text :message
      t.timestamps
    end
  end
end
