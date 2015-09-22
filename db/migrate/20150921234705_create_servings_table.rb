class CreateServingsTable < ActiveRecord::Migration
  def change
    create_table :servings do |t|
      t.references :plan, index: true, foreign_key: true
      t.references :repo, index: true, foreign_key: true
      t.integer :delivery
    end
  end
end
