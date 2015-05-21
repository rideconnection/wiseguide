class EventsController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def edit
    prep_edit
  end

  def new
    @event.attributes = {
      :user => current_user, 
      :kase_id => params[:kase_id], 
      :date => Date.current, 
      :start_time => "08:00 AM", 
      :end_time => "09:00 AM"
    }
    prep_edit
  end

  def create
    @kase = Kase.find(params[:event][:kase_id])
    authorize! :edit, @kase

    @event.user = current_user

    if @event.save
      redirect_to(@kase, :notice => 'Event was successfully created.') 
    else
      prep_edit
      render :action => "new"
    end
  end

  def update
    @kase = Kase.find(params[:event][:kase_id])
    authorize! :edit, @kase

    if @event.update_attributes(event_params)
      redirect_to(@kase, :notice => 'Event was successfully updated.') 
    else
      prep_edit
      render :action => "edit"
    end
  end

  def destroy
    @event.destroy
    redirect_to kase_url( @event.kase )
  end

  private

  def prep_edit
    @event_types = EventType.accessible_by(current_ability)
    @funding_sources = FundingSource.accessible_by(current_ability)
    @users = User.accessible_by(current_ability)
  end

  def event_params
    params.require(:event).permit(
      :date,
      :duration_in_hours,
      :end_time,
      :event_type_id,
      :funding_source_id,
      :kase_id,
      :notes,
      :show_full_notes,
      :start_time
    )
  end
end
