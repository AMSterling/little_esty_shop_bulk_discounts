class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :invoice_items

  enum status: { 'cancelled' => 0, 'in progress' => 1, 'complete' => 2 }

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discounted_revenue
    invoice_items.sum do |invoice_item|
      invoice_item.revenue
    end
  end

  def total_savings
    total_revenue - discounted_revenue
  end
end
