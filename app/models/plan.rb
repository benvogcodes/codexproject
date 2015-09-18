class Plan < ActiveRecord::Base
  belongs_to :user
  has_many :repos

  validates :user_id, presence: true
  validates :frequency, presence: true
  validates :query, presence: true
end
