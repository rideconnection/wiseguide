class ReferralTypesController < ApplicationController
  load_and_authorize_resource

  # GET /referral_types
  # GET /referral_types.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @referral_types }
    end
  end

  # GET /referral_types/1
  # GET /referral_types/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @referral_type }
    end
  end

  # GET /referral_types/new
  # GET /referral_types/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @referral_type }
    end
  end

  # GET /referral_types/1/edit
  def edit
  end

  # POST /referral_types
  # POST /referral_types.xml
  def create
    respond_to do |format|
      if @referral_type.save
        format.html { redirect_to(@referral_type, :notice => 'Referral type was successfully created.') }
        format.xml  { render :xml => @referral_type, :status => :created, :location => @referral_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @referral_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /referral_types/1
  # PUT /referral_types/1.xml
  def update
    respond_to do |format|
      if @referral_type.update_attributes(referral_type_params)
        format.html { redirect_to(@referral_type, :notice => 'Referral type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @referral_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /referral_types/1
  # DELETE /referral_types/1.xml
  def destroy
    @referral_type.destroy

    respond_to do |format|
      format.html { redirect_to(referral_types_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def referral_type_params
    params.require(:referral_type).permit(:name)
  end
end
