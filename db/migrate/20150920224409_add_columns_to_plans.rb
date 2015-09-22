class AddColumnsToPlans < ActiveRecord::Migration
  def change
    rename_column :plans, :query, :language
    add_column :plans, :cards_per_serve, :integer
    add_column :plans, :serves, :integer
  end
end
