class CreateUser < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false # required because `name` the only identifier for user
      t.timestamps
    end
  end
end
