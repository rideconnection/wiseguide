class TripReasonsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    if @trip_reason.save
      redirect_to(@trip_reason, notice: 'Trip reason was successfully created.')
    else
      render action: "new"
    end
  end

  def update
    if @trip_reason.update_attributes(trip_reason_params)
      redirect_to(@trip_reason, notice: 'Trip reason was successfully updated.') 
    else
      render action: "edit" 
    end
  end

  def destroy
    @trip_reason.destroy

    redirect_to(trip_reasons_url) 
  end
  
  private
  
  def trip_reason_params
    params.require(:trip_reason).permit(:name, :work_related)
  end
end
