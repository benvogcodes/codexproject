class AddMoreColumnsToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :served, :integer
    add_column :plans, :twilio, :boolean
    add_column :plans, :sendgrid, :boolean
  end
end
