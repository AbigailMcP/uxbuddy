class AddUserRefToTests < ActiveRecord::Migration[5.0]
  def change
    add_reference :tests, :user, foreign_key: true
  end
end
