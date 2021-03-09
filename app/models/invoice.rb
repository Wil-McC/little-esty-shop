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

  def discounted_total_revenue
    # discount = fetch discount
    # invoice_total_revenue - discount
    # iis.each do ???
  end

  def fetch_discount
    # if in discount_compute
    # discount_compute.first ( largest applicable discount )
  end

  def discount_compute
    out = invoice_items.joins(:discounts)
    .select('invoice_items.*, ((invoice_items.quantity * invoice_items.unit_price) * discounts.percentage) as gross_discount')
    .order('discounts.percentage')
    .where('invoice_items.quantity >= discounts.threshold')
    require "pry"; binding.pry
  end
end
