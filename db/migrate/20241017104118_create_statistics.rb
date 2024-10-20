class CreateStatistics < ActiveRecord::Migration[7.2]
  def change
    create_table :statistics do |t|
      t.references :player, null: false, foreign_key: true
      t.references :match, null: false, foreign_key: true

      t.integer :saves, default: 0
      t.integer :interceptions, default: 0
      t.integer :distribution, default: 0

      t.integer :goals, default: 0
      t.integer :assists, default: 0
      t.integer :shots, default: 0

      t.integer :tackles, default: 0 # goals assists

      t.integer :blocks, default: 0 # tackles assists

      t.timestamps
    end
  end
end
