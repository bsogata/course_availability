class CreateCourseLists < ActiveRecord::Migration
  def change
    create_table :course_lists do |t|
      t.string :name

      t.timestamps
    end
  end
end
