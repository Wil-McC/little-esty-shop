require 'rails_helper'

RSpec.describe 'when I visit the discount show page' do
  before :each do
    @merchant1 = create(:merchant)
    @disco1 = @merchant1.discounts.create!(percentage: 10, threshold: 12)
  end
  it 'I see discount percentage and threshold' do
    visit merchant_discount_path(@merchant1, @disco1)

    expect(page).to have_content(@merchant1.name)
    expect(page).to have_content(@disco1.id)
    expect(page).to have_content(@disco1.percentage)
    expect(page).to have_content(@disco1.threshold)
  end
end
