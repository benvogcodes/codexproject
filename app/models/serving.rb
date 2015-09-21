class Serving < ActiveRecord::Base
  belongs_to :plan
  has_and_belongs_to_many :repos
end
