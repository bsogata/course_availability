class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :text
    add_column :users, :email, :text
    add_column :users, :password_digest, :text
  end
end
