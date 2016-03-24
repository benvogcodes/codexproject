class AddDefaultsToPlans < ActiveRecord::Migration
  def change
    change_column :plans, :frequency, :string, default: 1
    change_column :plans, :cards_per_serve, :integer, default: 5
    change_column :plans, :serves, :integer, default: 5
    change_column :plans, :twilio, :boolean, default: false
    change_column :plans, :sendgrid, :boolean, default: false
    change_column :plans, :served, :integer, default: 0
    change_column :plans, :phone_number, :integer, default: 0
  end
end
