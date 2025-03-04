class Item < ApplicationRecord
  validates_presence_of :name,
                        :description,
                        :unit_price,
                        :merchant_id

  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :bulk_discounts, through: :merchant

  enum status: { 'disabled' => 0, 'enabled' => 1}

  def best_day
    invoices
    .joins(:invoice_items)
    .where('invoices.status = 2')
    .select('invoices.*, sum(invoice_items.unit_price * invoice_items.quantity) as money')
    .group(:id)
    .order("money desc", "created_at desc")
    .first&.created_at&.to_date
  end
end
