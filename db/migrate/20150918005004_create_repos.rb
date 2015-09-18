class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.references :plan, index: true, foreign_key: true
      t.boolean :served

      t.timestamps null: false
    end
  end
end
