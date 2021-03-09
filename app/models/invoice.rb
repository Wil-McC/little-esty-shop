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

  def invoice_discount_revenue
    gross = invoice_items.sum("invoice_items.quantity * invoice_items.unit_price").to_i
    gross - discount_total(invoice_items)
  end

  def merchant_total_revenue(merchant_id)
    merchant = Merchant.find(merchant_id)
    merchant.invoice_items.sum("invoice_items.quantity * invoice_items.unit_price").to_i
  end

  def discounted_total_revenue(merchant_id)
    merchant = Merchant.find(merchant_id)
    merchant_total_revenue(merchant_id) - discount_total(merchant.invoice_items)
  end

  def discounted_ids(invoice_items)
    invoice_items.ids & discount_compute.ids
  end

  def discount_total(invoice_items)
    if discounted_ids(invoice_items).empty?
      return 0
    else
      discount = discounted_ids(invoice_items).sum do |id|
        discount_compute.find(id).gross_discount
      end
      return (discount / 100).to_i
    end
  end

  def discount_compute
    invoice_items.joins(:discounts)
      .select('invoice_items.*, ((invoice_items.quantity * invoice_items.unit_price) * discounts.percentage) as gross_discount')
      .order('discounts.percentage DESC')
      .where('invoice_items.quantity >= discounts.threshold')
  end
end
