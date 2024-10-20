class CreateRoles < ActiveRecord::Migration[7.2]
  def change
    create_table :roles do |t|
      t.string :name
      t.jsonb :coefficients

      t.timestamps
    end
  end
end
