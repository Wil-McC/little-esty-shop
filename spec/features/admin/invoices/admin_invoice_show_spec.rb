require 'rails_helper'

RSpec.describe 'the admin invoice show page' do
  before :each do
    @merchant1 = create(:merchant)

    @customer1 = create(:customer)

    @item1 = create(:item, merchant_id: @merchant1.id)
    @item2 = create(:item, merchant_id: @merchant1.id)
    @item3 = create(:item, merchant_id: @merchant1.id)
    @item4 = create(:item, merchant_id: @merchant1.id)
    @item5 = create(:item, merchant_id: @merchant1.id)
    @item6 = create(:item, merchant_id: @merchant1.id)
    @item7 = create(:item, merchant_id: @merchant1.id)

    @invoice1 = create(:invoice, status: 1, created_at: "2013-03-25 09:54:09 UTC", customer_id: @customer1.id)

    @invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, status: 1, quantity: 6, unit_price: 101)
    @invoice_item2 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item2.id, status: 2, quantity: 5, unit_price: 102)
    @invoice_item3 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item3.id, status: 2, quantity: 4, unit_price: 103)
    @invoice_item4 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item4.id, status: 0, quantity: 3, unit_price: 104)
    @invoice_item5 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item5.id, status: 2, quantity: 2, unit_price: 105)
    @invoice_item6 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item6.id, status: 1, quantity: 1, unit_price: 106)
    @invoice_item7 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item7.id, status: 2, quantity: 1, unit_price: 107)
  end
  it "displays id status created at" do
    visit admin_invoice_path(@invoice1)

    expect(page).to have_content(@invoice1.id)
    expect(page).to have_content(@invoice1.status)
    expect(page).to have_content(@invoice1.created_at.strftime("%A, %B %d, %Y"))
  end
  it "displays customer names" do
    visit admin_invoice_path(@invoice1)

    expect(page).to have_content(@customer1.first_name)
    expect(page).to have_content(@customer1.last_name)
  end

  it "displays information for all items on invoice" do
    visit admin_invoice_path(@invoice1)

    expect(page).to have_content(@item1.name)
    expect(page).to have_content(@item2.name)
    expect(page).to have_content(@item3.name)
    expect(page).to have_content(@item4.name)
    expect(page).to have_content(@item5.name)
    expect(page).to have_content(@item6.name)
    expect(page).to have_content(@item7.name)
    expect(page).to have_content(@invoice_item1.quantity)
    expect(page).to have_content(@invoice_item2.quantity)
    expect(page).to have_content(@invoice_item3.quantity)
    expect(page).to have_content(@invoice_item4.quantity)
    expect(page).to have_content(@invoice_item5.quantity)
    expect(page).to have_content(@invoice_item6.quantity)
    expect(page).to have_content(@invoice_item7.quantity)
    expect(page).to have_content(@invoice_item1.unit_price)
    expect(page).to have_content(@invoice_item2.unit_price)
    expect(page).to have_content(@invoice_item3.unit_price)
    expect(page).to have_content(@invoice_item4.unit_price)
    expect(page).to have_content(@invoice_item5.unit_price)
    expect(page).to have_content(@invoice_item6.unit_price)

    expect(page).to have_content(@invoice_item1.status)
    expect(page).to have_content(@invoice_item2.status)
    expect(page).to have_content(@invoice_item3.status)
    expect(page).to have_content(@invoice_item4.status)
    expect(page).to have_content(@invoice_item5.status)
    expect(page).to have_content(@invoice_item6.status)
    expect(page).to have_content(@invoice_item7.status)
  end
  it "displays total invoice revenue" do
    visit admin_invoice_path(@invoice1)
    expect(page).to have_content("Total Invoice Revenue: $2263")
  end

  it "displays item status in dropdown" do
    visit admin_invoice_path(@invoice1)

    expect(page).to have_select("invoice_status", selected: "cancelled")
    select 'completed', from: "invoice_status"
    click_button("Update Invoice Status")
    expect(current_path).to eq(admin_invoice_path(@invoice1))
    expect(page).to have_select("invoice_status", selected: "completed")
  end
end

RSpec.describe 'bulk discounts' do
  before :each do
    @merchant1 = create(:merchant)
    @disco1 = @merchant1.discounts.create!(percentage: 20, threshold: 5)

    @customer1 = create(:customer)

    @item1 = create(:item, merchant_id: @merchant1.id)
    @item2 = create(:item, merchant_id: @merchant1.id)
    @item3 = create(:item, merchant_id: @merchant1.id)
    @item4 = create(:item, merchant_id: @merchant1.id)
    @item5 = create(:item, merchant_id: @merchant1.id)
    @item6 = create(:item, merchant_id: @merchant1.id)
    @item7 = create(:item, merchant_id: @merchant1.id)

    @invoice1 = create(:invoice, status: 1, created_at: "2013-03-25 09:54:09 UTC", customer_id: @customer1.id)

    @invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, status: 1, quantity: 6, unit_price: 100)
    @invoice_item2 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item2.id, status: 2, quantity: 5, unit_price: 100)
    @invoice_item3 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item3.id, status: 2, quantity: 4, unit_price: 100)
    @invoice_item4 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item4.id, status: 0, quantity: 3, unit_price: 100)
    @invoice_item5 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item5.id, status: 2, quantity: 2, unit_price: 100)
    @invoice_item6 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item6.id, status: 1, quantity: 1, unit_price: 100)
    @invoice_item7 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item7.id, status: 2, quantity: 1, unit_price: 100)
  end
  it "displays invoice revenue with discounts applied" do
    visit admin_invoice_path(@invoice1)

    expect(page).to have_content('Invoice Revenue w/ Discounts: $1980')
  end
end
