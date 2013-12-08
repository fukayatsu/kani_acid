class Chain < ActiveRecord::Base
  has_and_belongs_to_many :sentences
end