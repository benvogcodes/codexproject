class Serving < ActiveRecord::Base
  belongs_to :plan
  belongs_to :repo
end
