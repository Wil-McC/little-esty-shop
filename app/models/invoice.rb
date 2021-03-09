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

  def invoice_total_revenue
    invoice_items.sum("invoice_items.quantity * invoice_items.unit_price").to_i
  end

  def discounted_total_revenue # (merchant_id)
    # @merchant = Merchant.find(params[:merchant_id])
    invoice_total_revenue - discount_total(invoice_items)
  end

  def discount_total(invoice_items)
    discount = 0
    # if in discount_compute
    # add gross_discount to discount collector
    #
    # discount_compute.first ( largest applicable discount )
    # else if any? false, discount stays at 0

    discount += find(ii.id).gross_discount
    return (discount / 100)
  end

  def discount_compute
    out = invoice_items.joins(:discounts)
      .select('invoice_items.*, ((invoice_items.quantity * invoice_items.unit_price) * discounts.percentage) as gross_discount')
      .order('discounts.percentage')
      .where('invoice_items.quantity >= discounts.threshold')
    require "pry"; binding.pry
  end
end
