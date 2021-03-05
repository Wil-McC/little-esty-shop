class Merchants::DiscountsController < ApplicationController
  before_action :set_merchant, only: [:index, :show]
  before_action :set_discount, only: [:show]

  def index
  end

  def show
  end

  private

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def set_discount
    @discount = Discount.find(params[:id])
  end
end
