class User < ActiveRecord::Base
  has_many :plans
  has_many :servings
  has_secure_password

  validates :username, presence: true
  validates :username, uniqueness: true
end
