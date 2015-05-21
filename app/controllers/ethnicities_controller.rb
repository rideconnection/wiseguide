class EthnicitiesController < ApplicationController
  load_and_authorize_resource

  # GET /ethnicities
  # GET /ethnicities.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ethnicities }
    end
  end

  # GET /ethnicities/1
  # GET /ethnicities/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ethnicity }
    end
  end

  # GET /ethnicities/new
  # GET /ethnicities/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ethnicity }
    end
  end

  # GET /ethnicities/1/edit
  def edit
  end

  # POST /ethnicities
  # POST /ethnicities.xml
  def create
    respond_to do |format|
      if @ethnicity.save
        format.html { redirect_to(@ethnicity, :notice => 'Ethnicity was successfully created.') }
        format.xml  { render :xml => @ethnicity, :status => :created, :location => @ethnicity }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ethnicity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ethnicities/1
  # PUT /ethnicities/1.xml
  def update
    respond_to do |format|
      if @ethnicity.update_attributes(ethnicity_params)
        format.html { redirect_to(@ethnicity, :notice => 'Ethnicity was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ethnicity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ethnicities/1
  # DELETE /ethnicities/1.xml
  def destroy
    @ethnicity.destroy

    respond_to do |format|
      format.html { redirect_to(ethnicities_url, :notice => 'Ethnicity was successfully deleted.') }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def ethnicity_params
    params.require(:ethnicity).permit(:name)
  end
end
