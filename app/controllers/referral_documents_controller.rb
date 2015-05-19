class ReferralDocumentsController < ApplicationController
  load_and_authorize_resource

  def index; end

  def show; end

  def new
    @referral_document.kase_id = params[:kase_id]
    prep_edit
  end

  def edit
    prep_edit
  end

  def create
    @kase = Kase.find(params[:referral_document][:kase_id])
    authorize! :edit, @kase
    
    if @referral_document.save
      redirect_to(@kase, :notice => 'Referral document was successfully created.')
    else
      prep_edit
      render :action => "new"
    end
  end

  def update
    @kase = Kase.find(@referral_document.kase_id)
    authorize! :edit, @kase
    
    if @referral_document.update_attributes(referral_document_params)
      redirect_to(@kase, :notice => 'Referral document was successfully updated.')
    else
      prep_edit
      render :action => "edit"
    end
  end

  def destroy
    @kase = Kase.find(@referral_document.kase_id)
    authorize! :edit, @kase

    @referral_document.destroy
    redirect_to(kase_path(@referral_document.kase), :notice => 'Referral document was successfully deleted.')
  end
  
  private
  
  def prep_edit
    @resources = Resource.active
    if @referral_document.referral_document_resources.count == 0
      @referral_document.referral_document_resources.build
    end
  end
  
  def referral_document_params
    params.require(:referral_document).permit(
      :kase_id,
      :referral_document_resources_attributes => [
        :note,
        :resource_id
      ],
    )
  end
end
