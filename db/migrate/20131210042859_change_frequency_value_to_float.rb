class ChangeFrequencyValueToFloat < ActiveRecord::Migration
  def change
    change_column :users, :frequency_value, :float
  end
end
