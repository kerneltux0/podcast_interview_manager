class AddColumnToGuests < ActiveRecord::Migration[5.2]
  def change
    add_column :guests, :interview_id, :integer
  end
end
