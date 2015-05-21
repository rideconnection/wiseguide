class EventTypesController < ApplicationController
  load_and_authorize_resource

  # GET /event_types
  # GET /event_types.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @event_types }
    end
  end

  # GET /event_types/1
  # GET /event_types/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event_type }
    end
  end

  # GET /event_types/new
  # GET /event_types/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event_type }
    end
  end

  # GET /event_types/1/edit
  def edit
  end

  # POST /event_types
  # POST /event_types.xml
  def create
    respond_to do |format|
      if @event_type.save
        format.html { redirect_to(@event_type, :notice => 'Event type was successfully created.') }
        format.xml  { render :xml => @event_type, :status => :created, :location => @event_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /event_types/1
  # PUT /event_types/1.xml
  def update
    respond_to do |format|
      if @event_type.update_attributes(event_type_params)
        format.html { redirect_to(@event_type, :notice => 'Event type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /event_types/1
  # DELETE /event_types/1.xml
  def destroy
    @event_type.destroy

    respond_to do |format|
      format.html { redirect_to(event_types_url, :notice => 'Event type was successfully deleted.') }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def event_type_params
    params.require(:event_type).permit(:name, :require_notes)
  end
end
