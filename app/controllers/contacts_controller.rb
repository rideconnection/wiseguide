class ContactsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
    @readonly = true
    @contactable = @contact.contactable
    prep_edit
  end

  def edit
    @readonly = false
    @contactable = @contact.contactable
    prep_edit
  end

  def new
    @readonly = false
    @contactable = params[:contact][:contactable_type].classify.constantize.find(params[:contact][:contactable_id])
    @contact.attributes = {
      date_time: DateTime.current,
      user: current_user
    }
    prep_edit
  end

  def create
    @contactable = params[:contact][:contactable_type].classify.constantize.find(params[:contact][:contactable_id])
    authorize! :edit, @contactable

    @contact.user = current_user
    
    if @contact.save
      redirect_to(@contactable, notice: 'Contact was successfully created.') 
    else
      prep_edit
      render action: "new"
    end
  end

  def update
    @contactable = @contact.contactable
    authorize! :edit, @contactable

    if @contact.update_attributes(contact_params)
      redirect_to(@contact.contactable, notice: 'Contact was successfully updated.') 
    else
      prep_edit
      render action: "edit"
    end
  end

  def destroy
    authorize! :edit, @contact.contactable

    @contact.destroy
    redirect_to(@contact.contactable, notice: 'Contact was successfully deleted.') 
  end

  private

  def prep_edit
    @contact_methods = ['Phone', 'Email', 'Meeting', 'Case Action']
  end
  
  def contact_params
    params.require(:contact).permit(
      :contactable_id,
      :contactable_type,
      :date_time,
      :description,
      :method,
      :notes,
      :show_full_notes,
    )
  end
end
