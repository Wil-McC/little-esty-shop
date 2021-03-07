class InvoiceItem < ApplicationRecord
  validates_presence_of :quantity,
                        :unit_price,
                        :status
  belongs_to :invoice
  belongs_to :item
  has_many :merchants, through: :item
  has_many :customers, through: :invoice
  has_many :transactions, through: :invoice

  enum status: [ "pending", "packaged", "shipped" ]


    # get discounts
    # get discount thresholds
    # find lowest?
    # sum of ( for each invoice item, if quantity >= threshold, ( quantity * price ) * discounted
                                    # else quantity * price

  def self.total_revenue
    sum("invoice_items.quantity * invoice_items.unit_price").to_i
  end
end
