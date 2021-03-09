class InvoiceItem < ApplicationRecord
  validates_presence_of :quantity,
                        :unit_price,
                        :status
  belongs_to :invoice
  belongs_to :item
  has_many :merchants, through: :item
  has_many :discounts, through: :item
  # has_many :discounts, through: :merchants
  has_many :customers, through: :invoice
  has_many :transactions, through: :invoice

  enum status: [ "pending", "packaged", "shipped" ]

  def self.total_revenue
    sum("invoice_items.quantity * invoice_items.unit_price").to_i
  end

  def discount
    merchant = merchants.first
    if invoice.discount_applied.find(id)
      disco_id = invoice.discount_applied.find(id).discount_id
      disco = Discount.find(disco_id)
    else
      nil
    end
  end
end
