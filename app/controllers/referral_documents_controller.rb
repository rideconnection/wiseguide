class ReferralDocumentsController < ApplicationController
  load_and_authorize_resource

  def index; end

  def show; end

  def new
    @referral_document = ReferralDocument.new(:kase_id=>params[:kase_id])
    prep_edit
  end

  def edit
    prep_edit
  end

  def create
    @kase = Kase.find(params[:referral_document][:kase_id])
    authorize! :edit, @kase
    
    @referral_document = ReferralDocument.new(params[:referral_document])

    if @referral_document.save
      redirect_to(@kase, :notice => 'Referral document was successfully created.')
    else
      prep_edit
      render :action => "new"
    end
  end

  def update
    @kase = Kase.find(params[:referral_document][:kase_id])
    authorize! :edit, @kase
    
    if @referral_document.update_attributes(params[:referral_document])
      redirect_to(@kase, :notice => 'Referral document was successfully updated.')
    else
      prep_edit
      render :action => "edit"
    end
  end

  def destroy
    @referral_document.destroy
    redirect_to(@referral_document.kase)
  end
  
private
  
  def prep_edit
    @resources = Resource.active
    if !params[:referral_document].blank? and !params[:referral_document][:resources_attributes].blank?
      params[:referral_document][:resources_attributes].each do |resource|
        @referral_document.resources.build(ReferralDocumentResource.new.attributes.merge(resource[1].slice(*ReferralDocumentResource.new.attributes.keys)))
      end
    elsif @referral_document.resources.count == 0
      @referral_document.resources.build
    end
  end
end
