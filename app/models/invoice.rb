class Invoice < ApplicationRecord
  validates_presence_of :status
  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [ "in progress", "cancelled", "completed" ]

  def self.incomplete_invoices
    joins(:invoice_items)
    .where('invoice_items.status != ?', 2)
    .select('invoices.*, invoice_items.invoice_id AS invoice_id, invoices.created_at AS invoice_created_at')
    .order('invoice_created_at')
    .distinct
  end

  # get discounts
  # get discount thresholds
  # find lowest?
  # sum of ( for each invoice item, if quantity >= threshold, ( quantity * price ) * discounted
                                  # else quantity * price

  def get_discounts
    merchants.first.discounts
  end

  def total_revenue
    get_discounts
    gross = invoice_items.sum("invoice_items.quantity * invoice_items.unit_price").to_i
  end


end
