class AddPhoneToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :phone_number, :integer
  end
end
