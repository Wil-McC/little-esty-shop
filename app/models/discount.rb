class Discount < ApplicationRecord
  validate_presence_of :percentage,
                       :threshold

  belongs_to :merchant
end
