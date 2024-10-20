class CreatePlayers < ActiveRecord::Migration[7.2]
  def change
    create_table :players do |t|
      t.string :name
      t.references :team, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true
      t.integer :rating

      t.timestamps
    end
  end
end
