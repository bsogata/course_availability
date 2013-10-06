class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.text :name
      t.integer :crn
      t.integer :section
      t.text :title
      t.integer :credits
      t.text :instructor
      t.integer :seats
      t.text :days
      t.text :time
      t.text :room
      t.text :dates

      t.timestamps
    end
  end
end
