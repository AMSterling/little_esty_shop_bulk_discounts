require 'rails_helper'

RSpec.describe 'merchant bulk discount index' do
  it 'lists all discounts from the merchant' do
    merchant1 = Merchant.create!(name: 'Hair Care')

    customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Smith')
    customer_2 = Customer.create!(first_name: 'Cecilia', last_name: 'Jones')
    customer_3 = Customer.create!(first_name: 'Mariah', last_name: 'Carrey')
    customer_4 = Customer.create!(first_name: 'Leigh Ann', last_name: 'Bron')
    customer_5 = Customer.create!(first_name: 'Sylvester', last_name: 'Nader')
    customer_6 = Customer.create!(first_name: 'Herber', last_name: 'Kuhn')

    invoice_1 = Invoice.create!(customer_id: customer_1.id, status: 2)
    invoice_2 = Invoice.create!(customer_id: customer_1.id, status: 2)
    invoice_3 = Invoice.create!(customer_id: customer_2.id, status: 2)
    invoice_4 = Invoice.create!(customer_id: customer_3.id, status: 2)
    invoice_5 = Invoice.create!(customer_id: customer_4.id, status: 2)
    invoice_6 = Invoice.create!(customer_id: customer_5.id, status: 2)
    invoice_7 = Invoice.create!(customer_id: customer_6.id, status: 1)

    item_1 = Item.create!(name: "Shampoo", description: "This washes your hair", unit_price: 10, merchant_id: merchant1.id)
    item_2 = Item.create!(name: "Conditioner", description: "This makes your hair shiny", unit_price: 8, merchant_id: merchant1.id)
    item_3 = Item.create!(name: "Brush", description: "This takes out tangles", unit_price: 5, merchant_id: merchant1.id)
    item_4 = Item.create!(name: "Hair tie", description: "This holds up your hair", unit_price: 1, merchant_id: merchant1.id)

    ii_1 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_1.id, quantity: 1, unit_price: 10, status: 0)
    ii_2 = InvoiceItem.create!(invoice_id: invoice_1.id, item_id: item_2.id, quantity: 1, unit_price: 8, status: 0)
    ii_3 = InvoiceItem.create!(invoice_id: invoice_2.id, item_id: item_3.id, quantity: 1, unit_price: 5, status: 2)
    ii_4 = InvoiceItem.create!(invoice_id: invoice_3.id, item_id: item_4.id, quantity: 1, unit_price: 5, status: 1)
    ii_5 = InvoiceItem.create!(invoice_id: invoice_4.id, item_id: item_4.id, quantity: 1, unit_price: 5, status: 1)
    ii_6 = InvoiceItem.create!(invoice_id: invoice_5.id, item_id: item_4.id, quantity: 1, unit_price: 5, status: 1)
    ii_7 = InvoiceItem.create!(invoice_id: invoice_6.id, item_id: item_4.id, quantity: 1, unit_price: 5, status: 1)

    transaction1 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_1.id)
    transaction2 = Transaction.create!(credit_card_number: 230948, result: 1, invoice_id: invoice_3.id)
    transaction3 = Transaction.create!(credit_card_number: 234092, result: 1, invoice_id: invoice_4.id)
    transaction4 = Transaction.create!(credit_card_number: 230429, result: 1, invoice_id: invoice_5.id)
    transaction5 = Transaction.create!(credit_card_number: 102938, result: 1, invoice_id: invoice_6.id)
    transaction6 = Transaction.create!(credit_card_number: 879799, result: 1, invoice_id: invoice_7.id)
    transaction7 = Transaction.create!(credit_card_number: 203942, result: 1, invoice_id: invoice_2.id)

    discount1 = BulkDiscount.create!(percent_off: 10, thresholds: 15, merchant_id: merchant1.id)
    discount2 = BulkDiscount.create!(percent_off: 15, thresholds: 20, merchant_id: merchant1.id)
    discount3 = BulkDiscount.create!(percent_off: 20, thresholds: 30, merchant_id: merchant1.id)

    visit new_merchant_bulk_discount_path(merchant1)

    fill_in 'Percent off', with: 25
    fill_in 'Thresholds', with: 40
    select('enabled', from: :status)
    click_on 'Add'

    expect(current_path).to eq("/merchant/#{merchant1.id}/bulk_discounts")
    expect(page).to have_content('Percentage: 25%')
    expect(page).to have_content('Quantity Threshold: 40')
    expect(page).to have_content('Status: enabled')

    visit new_merchant_bulk_discount_path(merchant1)

    fill_in 'Thresholds', with: 40
    select('enabled', from: :status)
    click_on 'Add'

    expect(page).to have_content('Error')
  end
end

# bundle exec rspec spec/features/bulk_discounts/new_spec.rb
