require 'rails_helper'

RSpec.describe 'the merchants index' do
  it 'shows the names of all merchants as links' do
    merchant1 = Merchant.create!(name: 'Fake Merchant')
    merchant2 = Merchant.create!(name: 'Another Merchant')
    merchant3 = Merchant.create!(name: 'Faux Merchant')

    item1 = Item.create!(name: 'Crap', description: 'Because you buy stuff for no reason', unit_price: 9999, merchant_id: merchant1.id)
    item2 = Item.create!(name: 'Junk', description: 'You have room', unit_price: 10999, merchant_id: merchant1.id)
    item3 = Item.create!(name: 'BS', description: 'Filling the void in your life', unit_price: 11999, merchant_id: merchant1.id)
    merch2item = Item.create!(name: 'Impracticality', description: 'Underselling the other guy', unit_price: 11998, merchant_id: merchant2.id)

    visit merchants_path

    within ("#merchant-#{merchant1.id}") do
      expect(page).to have_link('Fake Merchant')
      expect(page).to_not have_content('Another Merchant')
      expect(page).to_not have_content('Faux Merchant')
    end

    within ("#merchant-#{merchant2.id}") do
      expect(page).to have_link('Another Merchant')
      expect(page).to_not have_content('Fake Merchant')
      expect(page).to_not have_content('Faux Merchant')
    end

    within ("#merchant-#{merchant3.id}") do
      expect(page).to have_link('Faux Merchant')
      expect(page).to_not have_content('Fake Merchant')
      expect(page).to_not have_content('Another Merchant')
    end

    click_link('Fake Merchant')
    expect(current_path).to eq("/merchants/#{merchant1.id}/dashboard")
    expect(page).to have_content('Fake Merchant')
    expect(page).to_not have_content('Another Merchant')
    expect(page).to_not have_content('Faux Merchant')
  end
end
