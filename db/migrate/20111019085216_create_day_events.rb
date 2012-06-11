class CreateDayEvents < ActiveRecord::Migration
  def change
    create_table :day_events do |t|
      t.string :title
      t.datetime :day
      t.boolean :all_day
      t.text :description
      t.integer :user_id
      t.integer :project_id

      t.timestamps
    end
  end
end
