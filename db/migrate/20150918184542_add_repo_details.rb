class AddRepoDetails < ActiveRecord::Migration
  def change
    add_column :repos, :url, :string
    add_column :repos, :stars, :integer
    add_column :repos, :forks, :integer
    add_column :repos, :size, :integer
    add_column :repos, :desc, :text
  end
end
