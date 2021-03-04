require "rails_helper"

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many :items }
    it { should have_many :discounts }
    it { should have_many(:invoice_items).through(:items)}
    it { should have_many(:invoices).through(:invoice_items)}
    it { should have_many(:transactions).through(:invoices)}
    it { should have_many(:customers).through(:invoices)}
  end

  describe "validations" do
    it { should validate_presence_of :name }
  end

  describe "Instance Methods" do
    before :each do
      @merchant1 = create(:merchant)

      @item = create(:item, merchant_id: @merchant1.id, status: true)
      @item2 = create(:item, merchant_id: @merchant1.id, status: true)
      @item3 = create(:item, merchant_id: @merchant1.id, status: true)
      @item4 = create(:item, merchant_id: @merchant1.id)
      @item5 = create(:item, merchant_id: @merchant1.id)
      @item6 = create(:item, merchant_id: @merchant1.id)

      @invoice = create(:invoice, created_at: "2013-03-25 09:54:09 UTC")
      @invoice2 = create(:invoice, created_at: "2012-03-17 09:54:09 UTC")
      @invoice3 = create(:invoice, created_at: "2011-03-01 09:54:09 UTC")
      @invoice4 = create(:invoice, created_at: "2020-03-25 09:54:09 UTC")

      @invoice_item = create(:invoice_item, invoice_id: @invoice.id, item_id: @item.id, status: 0)
      @invoice_item2 = create(:invoice_item, invoice_id: @invoice2.id, item_id: @item2.id, status: 1)
      @invoice_item3 = create(:invoice_item, invoice_id: @invoice3.id, item_id: @item3.id, status: 1)
      @invoice_item4 = create(:invoice_item, invoice_id: @invoice4.id, item_id: @item4.id, status: 0)
      @invoice_item5 = create(:invoice_item_with_invoices, item_id: @item5.id, status: 2)
      @invoice_item6 = create(:invoice_item_with_invoices, item_id: @item6.id, status: 2)

      @transactions = create_list(:transaction, 6, invoice_id: @invoice_item.invoice.id, result: "success")
      @transactions2 = create_list(:transaction, 7, invoice_id: @invoice_item2.invoice.id, result: "success")
      @transactions3 = create_list(:transaction, 8, invoice_id: @invoice_item3.invoice.id, result: "success")
      @transactions4 = create_list(:transaction, 9, invoice_id: @invoice_item4.invoice.id, result: "success")
      @transactions5 = create_list(:transaction, 10, invoice_id: @invoice_item5.invoice.id, result: "success")
      @transactions6 = create_list(:transaction, 11, invoice_id: @invoice_item6.invoice.id, result: "failed")

      @customer = @invoice_item.invoice.customer
      @customer2 = @invoice_item2.invoice.customer
      @customer3 = @invoice_item3.invoice.customer
      @customer4 = @invoice_item4.invoice.customer
      @customer5 = @invoice_item5.invoice.customer
      @customer6 = @invoice_item6.invoice.customer
    end

    describe "#find_top_customers" do
      it "Should return top 5 based on successful transactions" do
        expect(@merchant1.find_top_customers).to eq([@customer5, @customer4, @customer3, @customer2, @customer])
      end
      it "Shows the number of successful transactions" do
        expect(@merchant1.find_top_customers.first.transaction_count).to eq(10)
      end
    end
    describe "#items_not_shipped" do
      it "Should return items not shipped" do
        expect(@merchant1.items_not_shipped).to eq([@item3, @item2, @item, @item4])
      end
      it 'should return item invoice ids' do
        expect(@merchant1.items_not_shipped.first.invoice_id).to eq(@invoice_item3.invoice.id)
      end
      it 'should return invoice created at date' do
        expect(@merchant1.items_not_shipped.first.invoice_created_at).to eq(@invoice3.created_at)
      end
      it "should display invoice date ~Monday, July 18, 2019~" do
        expect(@merchant1.items_not_shipped[2].convert_date).to eq("Monday, March 25, 2013")
      end
      it "should order by date oldest first" do
        expect(@merchant1.items_not_shipped.first).to eq(@item3)
        expect(@merchant1.items_not_shipped.last).to eq(@item4)
      end

      it "#enabled_items" do
        expect(@merchant1.enabled_items).to eq([@item, @item2, @item3])
      end
      it "#disabled_items" do
        expect(@merchant1.disabled_items).to eq([@item4, @item5, @item6])
      end
    end
  end

  describe 'class methods' do
    before :each do
      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant)
      @merchant3 = create(:merchant)
      @merchant4 = create(:merchant)
      @merchant5 = create(:merchant)
      @merchant6 = create(:merchant)

      @item1 = create(:item, merchant_id: @merchant1.id)
      @item2 = create(:item, merchant_id: @merchant2.id)
      @item3 = create(:item, merchant_id: @merchant3.id)
      @item4 = create(:item, merchant_id: @merchant4.id)
      @item5 = create(:item, merchant_id: @merchant5.id)
      @item6 = create(:item, merchant_id: @merchant6.id)

      @invoice1 = create(:invoice)
      @invoice2 = create(:invoice)
      @invoice3 = create(:invoice)
      @invoice4 = create(:invoice)
      @invoice5 = create(:invoice)
      @invoice6 = create(:invoice)

      @invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, status: 1, quantity: 6, unit_price: 100)
      @invoice_item2 = create(:invoice_item, invoice_id: @invoice2.id, item_id: @item2.id, status: 1, quantity: 5, unit_price: 100)
      @invoice_item3 = create(:invoice_item, invoice_id: @invoice3.id, item_id: @item3.id, status: 0, quantity: 4, unit_price: 100)
      @invoice_item4 = create(:invoice_item, invoice_id: @invoice4.id, item_id: @item4.id, status: 2, quantity: 3, unit_price: 100)
      @invoice_item5 = create(:invoice_item, invoice_id: @invoice5.id, item_id: @item5.id, status: 0, quantity: 2, unit_price: 100)
      @invoice_item6 = create(:invoice_item, invoice_id: @invoice6.id, item_id: @item6.id, status: 2, quantity: 1, unit_price: 100)

      @transactions = create_list(:transaction, 6, invoice_id: @invoice_item1.invoice.id, result: "success")
      @transactions2 = create_list(:transaction, 7, invoice_id: @invoice_item2.invoice.id, result: "success")
      @transactions3 = create_list(:transaction, 8, invoice_id: @invoice_item3.invoice.id, result: "success")
      @transactions4 = create_list(:transaction, 9, invoice_id: @invoice_item4.invoice.id, result: "success")
      @transactions5 = create_list(:transaction, 10, invoice_id: @invoice_item5.invoice.id, result: "success")
      @transactions6 = create_list(:transaction, 11, invoice_id: @invoice_item6.invoice.id, result: "failed")
    end
    it 'Merchant::top_merchants' do
      expect(Merchant.top_merchants.first.name).to eq(@merchant1.name)
      expect(Merchant.top_merchants.second.name).to eq(@merchant2.name)
      expect(Merchant.top_merchants.third.name).to eq(@merchant3.name)
      expect(Merchant.top_merchants.fourth.name).to eq(@merchant4.name)
      expect(Merchant.top_merchants[4].name).to eq(@merchant5.name)
      expect(Merchant.top_merchants).not_to include(@merchant6)
    end
  end

  describe '#top_selling_date' do
    before :each do
      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant)

      @item1 = create(:item, merchant_id: @merchant1.id)
      @item2 = create(:item, merchant_id: @merchant1.id)
      @item3 = create(:item, merchant_id: @merchant2.id)
      @item4 = create(:item, merchant_id: @merchant2.id)

      @invoice1 = create(:invoice, created_at: "2013-03-25 09:54:09 UTC")
      @invoice2 = create(:invoice, created_at: "2012-03-17 09:54:09 UTC")
      @invoice3 = create(:invoice, created_at: "2011-03-01 09:54:09 UTC")
      @invoice4 = create(:invoice, created_at: "2020-03-25 09:54:09 UTC")

      @invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, status: 1, quantity: 6, unit_price: 100)
      @invoice_item2 = create(:invoice_item, invoice_id: @invoice2.id, item_id: @item2.id, status: 1, quantity: 2, unit_price: 100)
      @invoice_item3 = create(:invoice_item, invoice_id: @invoice3.id, item_id: @item3.id, status: 0, quantity: 6, unit_price: 100)
      @invoice_item4 = create(:invoice_item, invoice_id: @invoice4.id, item_id: @item4.id, status: 2, quantity: 2, unit_price: 100)

      @transactions = create(:transaction, invoice_id: @invoice_item1.invoice.id, result: "success")
      @transactions2 = create(:transaction, invoice_id: @invoice_item2.invoice.id, result: "success")
      @transactions3 = create(:transaction, invoice_id: @invoice_item3.invoice.id, result: "success")
      @transactions4 = create(:transaction, invoice_id: @invoice_item4.invoice.id, result: "success")
    end
    it 'returns a merchant top day by revenue' do
      expect(@merchant1.top_selling_date).to eq("Monday, March 25, 2013")
      expect(@merchant2.top_selling_date).to eq("Tuesday, March 01, 2011")
    end
  end
end
