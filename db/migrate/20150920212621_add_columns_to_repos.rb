class AddColumnsToRepos < ActiveRecord::Migration
  def change
    add_column :repos, :name, :string
    add_column :repos, :user, :string
    add_column :repos, :created, :datetime
    add_column :repos, :updated, :datetime
    add_column :repos, :pushed, :datetime
    add_column :repos, :watchers, :string
  end
end
