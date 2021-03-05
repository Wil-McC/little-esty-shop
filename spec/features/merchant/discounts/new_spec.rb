require 'rails_helper'

RSpec.describe 'the new discount form' do
  before :each do
    @merchant1 = create(:merchant)

    @disco1 = @merchant1.discounts.create!(percentage: 10, threshold: 12)
  end
  it 'creates a new discount when completed with valid data' do
    visit new_merchant_discount_path(@merchant1)

    fill_in 'discount_percentage', with: 10
    fill_in 'discount_threshold', with: 20

    click_on 'Create Discount'

    expect(current_path).to eq(merchant_discounts_path(@merchant1))
  end
end
