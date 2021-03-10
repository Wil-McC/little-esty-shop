class Discount < ApplicationRecord
  validates_presence_of :percentage,
                       :threshold

  belongs_to :merchant
  has_many :items, through: :merchant
end
