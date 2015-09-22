class User < ActiveRecord::Base
  has_many :plans, dependent: :destroy
  has_many :servings, dependent: :destroy
  has_secure_password

  validates :username, presence: true
  validates :username, uniqueness: true
end
