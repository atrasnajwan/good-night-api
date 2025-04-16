class AddMostUsedSortToIndex < ActiveRecord::Migration[7.1]
  def up
    # added because the logic often show sleep_records sort by created_at
    add_index :sleep_records, :created_at

    # added because the logic often show followings or followers sort by users.created_at
    add_index :users, :created_at
  end
end