class ContactsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
    @readonly = true
    prep_edit
  end

  def edit
    @readonly = false
    prep_edit
  end

  def new
    @readonly = false
    attrs = Hash.new
    if !params[:kase_id].blank? then
      @kase = Kase.find(params[:kase_id])
      attrs[:kase_id] = @kase.id
    end
    if !params[:customer_id].blank? then
      @customer = Customer.find(params[:customer_id])
    else
      @customer = @kase.customer
    end
    attrs[:customer_id] = @customer.id
    @contact = Contact.new(attrs.merge({
      :date_time=>DateTime.current,
      :user => current_user
    }))
    prep_edit
  end

  def create
    if !params[:contact][:kase_id].blank? then
      @kase = Kase.find(params[:contact][:kase_id])
      authorize! :edit, @kase
    else
      @customer = Customer.find(params[:contact][:customer_id])
      authorize! :edit, @customer
    end
    @contact = Contact.new(params[:contact])
    @contact.user = current_user
    if @contact.save
      if !params[:contact][:kase_id].blank? then
        redirect_to(@kase, :notice => 'Contact was successfully created.') 
      else
        redirect_to(@customer, :notice => 'Contact was successfully created.')
      end
    else
      prep_edit
      render :action => "new"
    end
  end

  def update
    if !params[:contact][:kase_id].blank? then
      @kase = Kase.find(params[:contact][:kase_id])
      authorize! :edit, @kase
    else
      @customer = Customer.find(params[:contact][:customer_id])
      authorize! :edit, @customer
    end
    if @contact.update_attributes(params[:contact])
      if !params[:contact][:kase_id].blank? then
        redirect_to(@kase, :notice => 'Contact was successfully updated.') 
      else
        redirect_to(@customer, :notice => 'Contact was successfully updated.')
      end
    else
      prep_edit
      render :action => "edit"
    end
  end

  def destroy
    @contact.destroy
    if !@contact.kase_id.blank? then
      redirect_to(@contact.kase, :notice => 'Contact was successfully deleted.') 
    else
      redirect_to(@contact.customer, :notice => 'Contact was successfully deleted.')
    end
  end

  private
  def prep_edit
    @contact_methods = ['Phone', 'Email', 'Meeting']
  end

end
