class AddSleepDurationToSleepRecords < ActiveRecord::Migration[7.1]
  def change
    # add as column because it will only changes once
    add_column :sleep_records, :sleep_duration, :decimal, precision: 10, scale: 2 # in hours
  end
end
