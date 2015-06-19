class OutcomesController < ApplicationController
  load_and_authorize_resource

  def index
  end

  def edit
    prep_edit
  end

  def new
    @outcome.kase_id = params[:kase_id]
    prep_edit
  end

  def create
    @kase = Kase.find(@outcome.kase_id)
    authorize! :edit, @kase

    if @outcome.save
      redirect_to(@kase, notice: 'Outcome was successfully created.') 
    else
      prep_edit
      render action: "new"
    end
  end

  def update
    @kase = Kase.find(@outcome.kase_id)
    authorize! :edit, @kase

    if @outcome.update_attributes(outcome_params)
      redirect_to(@kase, notice: 'Outcome was successfully updated.') 
    else
      prep_edit
      render action: "edit"
    end
  end

  def destroy
    @kase = Kase.find(@outcome.kase_id)
    authorize! :edit, @kase

    @outcome.destroy
    redirect_to(kase_path(@outcome.kase), notice: 'Outcome was successfully deleted.')
  end

  private

  def prep_edit
    @trip_reasons = TripReason.accessible_by(current_ability)
  end

  def outcome_params
    params.require(:outcome).permit(
      :exit_trip_count,
      :exit_vehicle_miles_reduced,
      :kase_id,
      :six_month_trip_count,
      :six_month_unreachable,
      :six_month_vehicle_miles_reduced,
      :three_month_trip_count,
      :three_month_unreachable,
      :three_month_vehicle_miles_reduced,
      :trip_reason_id,
    )
  end
end
