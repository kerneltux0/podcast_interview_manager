class CreateShows < ActiveRecord::Migration[5.2]
  def change
    create_table :shows do |t|
      t.string :title
      t.string :description
      t.string :category
      t.string :url
      t.string :duration
      t.integer :host_id
    end
  end
end
