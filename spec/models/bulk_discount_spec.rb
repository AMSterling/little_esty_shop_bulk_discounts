require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'validations' do
    it { should validate_presence_of :percent_off }
    it { should validate_presence_of :thresholds }
    it { should validate_numericality_of :thresholds }
    it { should validate_presence_of :merchant_id }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
  end
  #
  # it 'converts float to percentage' do
  #   merchant1 = Merchant.create!(name: 'Hair Care')
  #
  #   discount1 = BulkDiscount.create!(percent_off: 0.1, thresholds: 15, merchant_id: merchant1.id)
  #   discount2 = BulkDiscount.create!(percent_off: 0.15, thresholds: 20, merchant_id: merchant1.id)
  #   discount3 = BulkDiscount.create!(percent_off: 0.2, thresholds: 30, merchant_id: merchant1.id)
  #
  #   expect(discount1.to_percentage).to eq('10.0%')
  #   expect(discount2.to_percentage).to eq('15.0%')
  #   expect(discount3.to_percentage).to eq('20.0%')
  # end
end

# bundle exec rspec spec/models/bulk_discount_spec.rb
