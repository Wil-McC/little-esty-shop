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
  it 'I see a link to edit the discount that redirects to a form on click' do
    visit merchant_discount_path(@merchant1, @disco1)

    expect(page).to have_link('Edit Discount')

    click_on 'Edit Discount'
    expect(current_path).to eq(edit_merchant_discount_path(@merchant1, @disco1))
    
    expect(find_field(:discount_percentage).value).to eq "#{@disco1.percentage}"
    expect(find_field(:discount_threshold).value).to eq "#{@disco1.threshold}"
  end
end
