class CustomerSupportNetworkMembersController < ApplicationController
  load_and_authorize_resource

  def edit
  end

  def new
    @customer_support_network_member.attributes = {customer_id: params[:customer_id]}
  end

  def create
    @customer = Customer.find(params[:customer_support_network_member][:customer_id])
    authorize! :edit, @customer

    if @customer_support_network_member.save
      redirect_to(@customer, notice: 'Customer Support Network Member was successfully created.') 
    else
      render action: "new"
    end
  end

  def update
    @customer = Customer.find(params[:customer_support_network_member][:customer_id])
    authorize! :edit, @customer

    if @customer_support_network_member.update_attributes(customer_support_network_member_params)
      redirect_to(@customer, notice: 'Customer Support Network Member was successfully updated.') 
    else
      render action: "edit"
    end
  end

  def destroy
    @customer = @customer_support_network_member.customer
    @customer_support_network_member.destroy
    redirect_to(@customer)
  end

  private
  
  def customer_support_network_member_params
    params.require(:customer_support_network_member).permit(
      :customer_id,
      :email,
      :name,
      :organization,
      :phone_number,
      :title,
    )
  end
end
