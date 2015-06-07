class ImpairmentsController < ApplicationController
  load_and_authorize_resource

  # GET /impairments
  # GET /impairments.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @impairments }
    end
  end

  # GET /impairments/1
  # GET /impairments/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @impairment }
    end
  end

  # GET /impairments/new
  # GET /impairments/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @impairment }
    end
  end

  # GET /impairments/1/edit
  def edit
  end

  # POST /impairments
  # POST /impairments.xml
  def create
    respond_to do |format|
      if @impairment.save
        format.html { redirect_to(@impairment, notice: 'Impairment was successfully created.') }
        format.xml  { render xml: @impairment, status: :created, location: @impairment }
      else
        format.html { render action: "new" }
        format.xml  { render xml: @impairment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /impairments/1
  # PUT /impairments/1.xml
  def update
    respond_to do |format|
      if @impairment.update_attributes(impairment_params)
        format.html { redirect_to(@impairment, notice: 'Impairment was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @impairment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /impairments/1
  # DELETE /impairments/1.xml
  def destroy
    @impairment.destroy

    respond_to do |format|
      format.html { redirect_to(impairments_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def impairment_params
    params.require(:impairment).permit(:name)
  end
end
