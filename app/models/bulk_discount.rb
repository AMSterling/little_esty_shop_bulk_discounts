class BulkDiscount < ApplicationRecord
  validates_presence_of :percent_off
  validates_presence_of :thresholds
  validates_numericality_of :thresholds
  validate :status
  validates_presence_of :merchant_id

  belongs_to :merchant

  enum status: { 'disabled' => 0, 'enabled' => 1}
end
