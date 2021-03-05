class Merchants::DiscountsController < ApplicationController
  before_action :set_merchant, only: [:index, :show, :new]
  before_action :set_discount, only: [:show]

  def index
  end

  def show
  end

  def new
  end

  def create
    
  end

  private

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def set_discount
    @discount = Discount.find(params[:id])
  end
end
