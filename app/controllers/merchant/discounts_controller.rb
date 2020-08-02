class Merchant::DiscountsController < Merchant::BaseController

  def new
  end

  def index
    @merchant_employee = User.find(current_user.id)
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    @discount.update(discount_params)
    if @discount.save
      redirect_to "/merchant/discounts"
    else
      render :edit
    end
  end

  def create
    merchant = Merchant.find(current_user.merchant.id)
    @discount = merchant.discounts.create(discount_params)
    if @discount.save
      flash[:success] = "Added #{@discount.name} to discounts"
      redirect_to "/merchant/discounts"
    else
      generate_flash(@discount)
      render :new
    end
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    flash[:success] = "#{discount.name} has been deleted"
    redirect_to "/merchant/discounts"
  end

  private

  def discount_params
    params.permit(:name, :item_quantity, :discount_percentage)
  end
end
