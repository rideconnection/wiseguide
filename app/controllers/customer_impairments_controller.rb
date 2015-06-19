class CustomerImpairmentsController < ApplicationController
  load_and_authorize_resource
  before_filter :load_and_authorize_customer
  
  def new
    @impairments = Impairment.all
    @customer_impairment.customer = @customer
  end
  
  def create
    if @customer_impairment.save
      redirect_to @customer, notice: 'Special consideration was successfully created.'
    else
      @impairments = Impairment.all
      render action: :new
    end
  end
  
  def edit
    @impairments = Impairment.all
  end
  
  def update
    if @customer_impairment.update_attributes(customer_impairment_params)
      redirect_to @customer, notice: 'Special consideration was successfully created.'
    else
      @impairments = Impairment.all
      render action: :edit
    end
  end
  
  def destroy
    @customer_impairment.destroy
    redirect_to @customer
  end
  
  private
  
  def load_and_authorize_customer
    @customer = params[:customer_id].present? ? Customer.find(params[:customer_id]) : @customer_impairment.customer
    authorize! :edit, @customer
  end
  
  def customer_impairment_params
    params.require(:customer_impairment).permit(:customer_id, :impairment_id, :notes)
  end
end
