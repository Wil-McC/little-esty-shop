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
  it "has a link to a new discount form that redirects" do
    visit merchant_discounts_path(@merchant1)

    expect(page).to have_link('Create New Discount')

    click_on 'Create New Discount'

    expect(current_path).to eq(new_merchant_discount_path(@merchant1))
  end
  it 'displays the next 3 upcoming holidays in a holidays section' do
    visit merchant_discounts_path(@merchant1)

    within(".upcoming_holidays") do
      expect(page).to have_content('Upcoming Holidays')
      expect(page).to have_content('Memorial Day - 2021-05-31')
      expect(page).to have_content('Independence Day - 2021-07-05')
      expect(page).to have_content('Labor Day - 2021-09-06')
      expect(page).to_not have_content('Columbus Day - 2021-10-11')
    end
  end
  it "has a link to delete each discount from merchant" do
    visit merchant_discounts_path(@merchant1)

    within("#discount-#{@disco1.id}") do
      expect(page).to have_link('Delete Discount')
      click_on 'Delete Discount'
    end

    expect(page).to_not have_content("#discount-#{@disco1.id}")
    expect(page).to have_content("Discount Successfully Deleted")
    expect(current_path).to eq(merchant_discounts_path(@merchant1))
  end
end
