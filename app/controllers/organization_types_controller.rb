class OrganizationTypesController < ApplicationController
  # GET /organization_types
  # GET /organization_types.xml
  def index
    @organization_types = OrganizationType.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @organization_types }
    end
  end

  # GET /organization_types/1
  # GET /organization_types/1.xml
  def show
    @organization_type = OrganizationType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organization_type }
    end
  end

  # GET /organization_types/new
  # GET /organization_types/new.xml
  def new
    @organization_type = OrganizationType.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organization_type }
    end
  end

  # GET /organization_types/1/edit
  def edit
    @organization_type = OrganizationType.find(params[:id])
  end

  # POST /organization_types
  # POST /organization_types.xml
  def create
    @organization_type = OrganizationType.new(params[:organization_type])

    respond_to do |format|
      if @organization_type.save
        format.html { redirect_to(@organization_type, :notice => 'Organization type was successfully created.') }
        format.xml  { render :xml => @organization_type, :status => :created, :location => @organization_type }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organization_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /organization_types/1
  # PUT /organization_types/1.xml
  def update
    @organization_type = OrganizationType.find(params[:id])

    respond_to do |format|
      if @organization_type.update_attributes(params[:organization_type])
        format.html { redirect_to(@organization_type, :notice => 'Organization type was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organization_type.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /organization_types/1
  # DELETE /organization_types/1.xml
  def destroy
    @organization_type = OrganizationType.find(params[:id])
    @organization_type.destroy

    respond_to do |format|
      format.html { redirect_to(organization_types_url) }
      format.xml  { head :ok }
    end
  end
end
