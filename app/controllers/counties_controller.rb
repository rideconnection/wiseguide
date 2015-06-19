class CountiesController < ApplicationController
  load_and_authorize_resource
  
  # GET /counties
  # GET /counties.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @counties }
    end
  end

  # GET /counties/1
  # GET /counties/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @county }
    end
  end

  # GET /counties/new
  # GET /counties/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @county }
    end
  end

  # GET /counties/1/edit
  def edit
  end

  # POST /counties
  # POST /counties.xml
  def create
    respond_to do |format|
      if @county.save
        format.html { redirect_to(@county, notice: 'County was successfully created.') }
        format.xml  { render xml: @county, status: :created, location: @county }
      else
        format.html { render action: "new" }
        format.xml  { render xml: @county.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /counties/1
  # PUT /counties/1.xml
  def update
    respond_to do |format|
      if @county.update_attributes(county_params)
        format.html { redirect_to(@county, notice: 'County was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @county.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /counties/1
  # DELETE /counties/1.xml
  def destroy
    @county.destroy

    respond_to do |format|
      format.html { redirect_to(counties_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def county_params
    params.require(:county).permit(:name)
  end
end
