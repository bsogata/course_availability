class AddFrequencyToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :frequency_value, :integer
  	add_column :users, :frequency, :text
  end
end
