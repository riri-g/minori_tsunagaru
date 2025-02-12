class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms, if_not_exists: true do |t|

      t.timestamps
    end
  end
end
