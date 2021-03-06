require "rails_helper"

RSpec.describe Invoice, type: :model do
  describe "relationships" do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
  end

  describe "validations" do
    it { should validate_presence_of :status }
  end

  describe "class methods" do
    it "#incomplete_invoices" do
      @merchant1 = create(:merchant)

      @customer1 = create(:customer)

      @item1 = create(:item, merchant_id: @merchant1.id)
      @item2 = create(:item, merchant_id: @merchant1.id)
      @item3 = create(:item, merchant_id: @merchant1.id)
      @item4 = create(:item, merchant_id: @merchant1.id)

      @invoice1 = create(:invoice, created_at: "2013-03-25 09:54:09 UTC")
      @invoice2 = create(:invoice, created_at: "2012-03-17 09:54:09 UTC")
      @invoice3 = create(:invoice, created_at: "2011-03-01 09:54:09 UTC")
      @invoice4 = create(:invoice, created_at: "2020-03-25 09:54:09 UTC")

      @invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, status: 1, quantity: 6, unit_price: 100)
      @invoice_item2 = create(:invoice_item, invoice_id: @invoice2.id, item_id: @item2.id, status: 1, quantity: 5, unit_price: 100)
      @invoice_item3 = create(:invoice_item, invoice_id: @invoice3.id, item_id: @item3.id, status: 0, quantity: 4, unit_price: 100)
      @invoice_item4 = create(:invoice_item, invoice_id: @invoice4.id, item_id: @item4.id, status: 2, quantity: 3, unit_price: 100)

      expected = [@invoice3, @invoice2, @invoice1]

      expect(Invoice.incomplete_invoices).to eq(expected)
      expect(Invoice.incomplete_invoices.first).to eq(@invoice3)
      expect(Invoice.incomplete_invoices.last).to eq(@invoice1)
    end
  end
  describe 'instance methods' do
    before :each do
      @merchant1 = create(:merchant)
      @merchant2 = create(:merchant)
      @merchant3 = create(:merchant)

      @disco1 = @merchant1.discounts.create!(percentage: 20, threshold: 5)
      @disco2 = @merchant1.discounts.create!(percentage: 50, threshold: 10)

      @customer1 = create(:customer)

      @item1 = create(:item, merchant_id: @merchant1.id)
      @item2 = create(:item, merchant_id: @merchant1.id)
      @item3 = create(:item, merchant_id: @merchant1.id)
      @item4 = create(:item, merchant_id: @merchant1.id)
      @item5 = create(:item, merchant_id: @merchant1.id)
      @item6 = create(:item, merchant_id: @merchant1.id)
      @item7 = create(:item, merchant_id: @merchant2.id)

      @item8 = create(:item, merchant_id: @merchant3.id)
      @item9 = create(:item, merchant_id: @merchant3.id)


      @invoice1 = create(:invoice, created_at: "2013-03-25 09:54:09 UTC", customer_id: @customer1.id)
      @invoice2 = create(:invoice)

      @invoice_item1 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item1.id, status: 1, quantity: 6, unit_price: 100)
      @invoice_item2 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item2.id, status: 2, quantity: 5, unit_price: 100)
      @invoice_item3 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item3.id, status: 2, quantity: 4, unit_price: 100)
      @invoice_item4 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item4.id, status: 0, quantity: 3, unit_price: 100)
      @invoice_item5 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item5.id, status: 2, quantity: 2, unit_price: 100)
      @invoice_item6 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item6.id, status: 1, quantity: 1, unit_price: 100)
      @invoice_item7 = create(:invoice_item, invoice_id: @invoice1.id, item_id: @item7.id, status: 2, quantity: 3, unit_price: 100)

      @invoice_item8 = create(:invoice_item, invoice_id: @invoice2.id, item_id: @item8.id, status: 2, quantity: 2, unit_price: 100)
      @invoice_item9 = create(:invoice_item, invoice_id: @invoice2.id, item_id: @item9.id, status: 1, quantity: 1, unit_price: 100)
    end
    it "#invoice_total_revenue" do
      expect(@invoice1.invoice_total_revenue).to eq(2400)
    end

    describe 'bulk discounts' do
      it "discount_compute" do
        expect(@invoice1.discount_compute.length).to eq(2)
      end
      it "invoice_discount_revenue returns total discounted revenue from all merchants and items" do
        disco3 = @merchant2.discounts.create!(percentage: 25, threshold: 2)

        expect(@invoice1.invoice_discount_revenue).to eq(2105)
      end
      it "discounted_total_revenue" do
        disco3 = @merchant2.discounts.create!(percentage: 25, threshold: 2)

        expect(@invoice1.discounted_total_revenue(@merchant1.id)).to eq(1880)
        expect(@invoice1.discounted_total_revenue(@merchant2.id)).to eq(225)
      end
      it "prefers highest applicable discount" do
        @disco4 = @merchant1.discounts.create!(percentage: 30, threshold: 5)

        expect(@invoice1.discounted_total_revenue(@merchant1.id)).to eq(1770)
      end
      it "discount total returns total discount of an invoice item set" do
        iis = @invoice1.invoice_items

        expect(@invoice1.discount_total(iis)).to eq(220)
      end
      it "discount_total return zero when no iis are eligible" do
        iis = @invoice2.invoice_items

        expect(@invoice2.discount_total(iis)).to eq(0)
      end
      it "discounted ids returns only eligible ii ids" do
        iis = @invoice1.invoice_items

        expect(@invoice1.discounted_ids(iis).length).to eq(2)
      end
      it "discount applied returns discount ids that were applied" do
        expect(@invoice1.discount_applied.length).to eq(2)
      end
    end
  end
end
