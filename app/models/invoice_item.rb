class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item
  has_many :bulk_discounts, through: :item
  has_one :merchant, through: :item
  has_one :cutomer, through: :invoice

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def eligible
    bulk_discounts.order(percent_off: :desc).where('thresholds <= ?', "#{self.quantity}").first
  end

  def revenue
    full_price = unit_price * quantity
    if eligible.nil?
      full_price
    else
      amount_off = full_price / eligible.percent_off
      return full_price - amount_off
    end
  end
end
