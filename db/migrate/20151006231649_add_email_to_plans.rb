class AddEmailToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :email, :string
  end
end
