class Merchants::DiscountsController < ApplicationController
  before_action :set_merchant, only: [:index, :show, :new, :create, :destroy, :update, :edit]
  before_action :set_discount, only: [:show, :edit, :update]

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def update
    @discount.update(discount_params)
    redirect_to merchant_discount_path(@merchant, @discount)
  end

  def create
    @discount = @merchant.discounts.new(discount_params)
    if @discount.save
      flash[:notice] = "Discount Created Successfully"
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:notice] = "Required Information Missing"
      render :new
    end
  end

  def destroy
    if @merchant.discounts.destroy(params[:id])
      flash[:notice] = "Discount Successfully Deleted"
      redirect_to merchant_discounts_path(@merchant)
    else
      flash[:notice] = "Something went wrong - Please contact administrator"
    end
  end

  private

  def set_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def set_discount
    @discount = Discount.find(params[:id])
  end

  def discount_params
    params.require(:discount).permit(:percentage, :threshold)
  end
end
