class CreateInterviews < ActiveRecord::Migration[5.2]
  def change
    create_table :interviews do |t|
      t.string :date
      t.boolean :recorded, :default => false
      t.boolean :published, :default => false
      t.integer :show_id
      t.integer :guest_id
      t.string :start_time
      t.string :end_time
    end
  end
end
