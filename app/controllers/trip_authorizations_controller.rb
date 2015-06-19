class TripAuthorizationsController < ApplicationController
  load_and_authorize_resource
  
  # GET /trip_authorizations
  # GET /trip_authorizations.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trip_authorizations }
    end
  end

  # GET /trip_authorizations/1
  # GET /trip_authorizations/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trip_authorization }
    end
  end

  # GET /trip_authorizations/new
  # GET /trip_authorizations/new.json
  def new
    @trip_authorization.kase_id = params[:kase_id]
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trip_authorization }
    end
  end

  # GET /trip_authorizations/1/edit
  def edit; end

  # POST /trip_authorizations
  # POST /trip_authorizations.json
  def create
    respond_to do |format|
      if @trip_authorization.save
        format.html { redirect_to @trip_authorization, notice: 'Trip authorization was successfully created.' }
        format.json { render json: @trip_authorization, status: :created, location: @trip_authorization }
      else
        format.html { render action: "new" }
        format.json { render json: @trip_authorization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trip_authorizations/1
  # PUT /trip_authorizations/1.json
  def update
    respond_to do |format|
      if @trip_authorization.update_attributes(trip_authorization_params)
        format.html { redirect_to @trip_authorization, notice: 'Trip authorization was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @trip_authorization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trip_authorizations/1
  # DELETE /trip_authorizations/1.json
  def destroy
    @trip_authorization.destroy

    respond_to do |format|
      format.html { redirect_to trip_authorizations_url }
      format.json { head :no_content }
    end
  end

  # PUT /trip_authorizations/1/complete_disposition
  # PUT /trip_authorizations/1/complete_disposition.json
  def complete_disposition
    respond_to do |format|
      if @trip_authorization.complete_disposition(current_user)
        format.html { redirect_to @trip_authorization, notice: 'Trip authorization disposition was successfully completed.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @trip_authorization.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
  
  def trip_authorization_params
    params.require(:trip_authorization).permit(
      :allowed_trips_per_month, 
      :disposition_date, 
      :disposition_user_id, 
      :end_date,
      :kase_id, 
      :start_date,
    )
  end
end
