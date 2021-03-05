require 'rails_helper'

RSpec.describe 'when I visit the merchant dashboard page' do
  before :each do
    @merchant1 = create(:merchant)
  end

  it 'I see a link to associated discount index that redirects on click' do
    visit merchant_dashboard_index_path(@merchant1)

    expect(page).to have_link("View #{@merchant1.name}'s Discounts")

    click_on "View #{@merchant1.name}'s Discounts"

    expect(current_path).to eq(merchant_discounts_path(@merchant1))
  end
end
