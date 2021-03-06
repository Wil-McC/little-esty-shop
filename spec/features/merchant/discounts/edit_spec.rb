require 'rails_helper'

RSpec.describe 'when I visit the discount edit page' do
  before :each do
    @merchant1 = create(:merchant)
    @disco1 = @merchant1.discounts.create!(percentage: 10, threshold: 12)
  end
  it 'redirects and updates on form submit' do
    visit edit_merchant_discount_path(@merchant1, @disco1)

    fill_in :discount_percentage, with: 25
    fill_in :discount_threshold, with: 10

    click_on 'Update Discount'

    expect(current_path).to eq(merchant_discount_path(@merchant1, @disco1))

    expect(page).to have_content('Discount Percentage: 25%')
    expect(page).to have_content('Discount Threshold: 10')
  end
  it 'redirects and updates on partial completion form submit' do
    visit edit_merchant_discount_path(@merchant1, @disco1)

    fill_in :discount_percentage, with: 25

    click_on 'Update Discount'

    expect(current_path).to eq(merchant_discount_path(@merchant1, @disco1))

    expect(page).to have_content('Discount Percentage: 25%')
    expect(page).to have_content('Discount Threshold: 12')
  end
end
