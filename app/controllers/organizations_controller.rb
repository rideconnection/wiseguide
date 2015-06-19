class OrganizationsController < ApplicationController
  load_and_authorize_resource

  # GET /organizations
  # GET /organizations.xml
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render xml: @organizations }
    end
  end

  # GET /organizations/1
  # GET /organizations/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @organization }
      format.json { render json: @organization }
    end
  end

  # GET /organizations/new
  # GET /organizations/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @organization }
    end
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  # POST /organizations.xml
  def create
    respond_to do |format|
      if @organization.save
        format.html { redirect_to(@organization, notice: 'Organization was successfully created.') }
        format.xml  { render xml: @organization, status: :created, location: @organization }
      else
        format.html { render action: "new" }
        format.xml  { render xml: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /organizations/1
  # PUT /organizations/1.xml
  def update
    respond_to do |format|
      if @organization.update_attributes(organization_params)
        format.html { redirect_to(@organization, notice: 'Organization was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.xml
  def destroy
    if !@organization.users.empty?
      respond_to do |format|
        format.html { redirect_to(@organization, alert: 'You cannot delete an organization that still has users assigned to it.') }
        format.xml  { render xml: @organization.errors, status: :unprocessable_entity }
      end
    else
      @organization.destroy

      respond_to do |format|
        format.html { redirect_to(organizations_url, notice: 'Organization was successfully deleted.') }
        format.xml  { head :ok }
      end
    end
  end
  
  private
  
  def organization_params
    params.require(:organization).permit(:name, :parent_id, :organization_type)
  end
end
