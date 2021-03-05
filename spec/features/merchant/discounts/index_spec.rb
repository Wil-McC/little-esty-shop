require 'rails_helper'

RSpec.describe 'when I visit the merchant discount index page' do
  before :each do
    @merchant1 = create(:merchant)

    @disco1 = @merchant1.discounts.create!(percentage: 10, threshold: 12)
  end
  it 'displays discounts with percentage and threshold' do
    visit merchant_discounts_path(@merchant1)

    within("#discount-#{@disco1.id}") do
      expect(page).to have_content(@disco1.percentage)
      expect(page).to have_content(@disco1.threshold)
      expect(page).to have_link("Discount Info Page")
      click_on "Discount Info Page"
    end

    expect(current_path).to eq(merchant_discount_path(@merchant1, @disco1))
  end
  it 'displays the next 3 upcoming holidays in a holidays section'
end
