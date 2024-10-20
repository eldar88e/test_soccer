class AddRatingToStatistics < ActiveRecord::Migration[7.2]
  def change
    add_column :statistics, :rating, :integer
  end
end
