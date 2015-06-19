class AdaServiceEligibilityStatusesController < ApplicationController
  load_and_authorize_resource

  # GET /ada_service_eligibility_statuses
  # GET /ada_service_eligibility_statuses.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @ada_service_eligibility_statuses }
    end
  end

  # GET /ada_service_eligibility_statuses/1
  # GET /ada_service_eligibility_statuses/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @ada_service_eligibility_status }
    end
  end

  # GET /ada_service_eligibility_statuses/new
  # GET /ada_service_eligibility_statuses/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @ada_service_eligibility_status }
    end
  end

  # GET /ada_service_eligibility_statuses/1/edit
  def edit
  end

  # POST /ada_service_eligibility_statuses
  # POST /ada_service_eligibility_statuses.xml
  def create
    respond_to do |format|
      if @ada_service_eligibility_status.save
        format.html { redirect_to(@ada_service_eligibility_status, notice: 'Ada service eligibility status was successfully created.') }
        format.xml  { render xml: @ada_service_eligibility_status, status: :created, location: @ada_service_eligibility_status }
      else
        format.html { render action: "new" }
        format.xml  { render xml: @ada_service_eligibility_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /ada_service_eligibility_statuses/1
  # PUT /ada_service_eligibility_statuses/1.xml
  def update
    respond_to do |format|
      if @ada_service_eligibility_status.update_attributes(ada_service_eligibility_status_params)
        format.html { redirect_to(@ada_service_eligibility_status, notice: 'Ada service eligibility status was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @ada_service_eligibility_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ada_service_eligibility_statuses/1
  # DELETE /ada_service_eligibility_statuses/1.xml
  def destroy
    @ada_service_eligibility_status.destroy

    respond_to do |format|
      format.html { redirect_to(ada_service_eligibility_statuses_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def ada_service_eligibility_status_params
    params.require(:ada_service_eligibility_status).permit(:name)
  end
end
