class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :discounts
  has_many :invoice_items, through: :items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices
  has_many :customers, through: :invoices

  def self.top_merchants
    left_joins(:transactions)
    .where('transactions.result = ?', "success")
    .group('merchants.id')
    .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue')
    .order('revenue DESC')
    .limit(5)
  end

  def most_popular_items
    items.joins(:invoice_items, :transactions)
      .where('transactions.result = ?', "success")
      .group('items.id')
      .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) AS revenue')
      .order('revenue DESC')
      .limit(5)
  end

  def find_top_customers
    customers.joins(:invoices, :transactions)
      .where('transactions.result = ?', "success")
      .group('customers.id')
      .select('customers.*, count(*) AS transaction_count')
      .order('transaction_count DESC')
      .limit(5)
  end

  def items_not_shipped
    items.joins(:invoice_items)
    .joins(:invoices)
    .where('invoice_items.status != ?', 2)
    .select('items.*, invoice_items.invoice_id AS invoice_id, invoices.created_at AS invoice_created_at')
    .order('invoice_created_at')
  end

  def top_selling_date
    sales_by_day = invoices.joins(:invoice_items)
    .group("date_trunc('day', invoices.created_at)")
    .sum('invoice_items.quantity * invoice_items.unit_price')
    sales_by_day.key(sales_by_day.values.max).strftime("%A, %B %d, %Y")
  end

  def self.enabled
    where(status: true)
  end

  def self.disabled
    where(status: false)
  end

  def enabled_items
    items.where(status: true)
  end

  def disabled_items
    items.where(status: false)
  end

  def enable_merchant
    update(status: true)
  end

  def disable_merchant
    update(status: false)
  end
end
