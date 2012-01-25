class ResourcesController < ApplicationController
  load_and_authorize_resource

  # GET /resources
  # GET /resources.xml
  def index
    @resources = Resource.all
    @active_resources = Resource.where(:active => true)
    @inactive_resources = Resource.where(:active => false)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @resources }
    end
  end

  # GET /resources/1
  # GET /resources/1.xml
  def show
    @resource = Resource.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @resource }
    end
  end

  # GET /resources/new
  # GET /resources/new.xml
  def new
    authorize! :edit, Resource
    @resource = Resource.new(:active => true)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @resource }
    end
  end

  # GET /resources/1/edit
  def edit
    @resource = Resource.find(params[:id])
    authorize! :edit, @resource
  end

  # POST /resources
  # POST /resources.xml
  def create
    authorize! :edit, Resource
    @resource = Resource.new(params[:resource])

    respond_to do |format|
      if @resource.save
        format.html { redirect_to(resources_path,
                      :notice => "#{@resource.name} successfully created.") }
        format.xml  { render :xml => @resource,
                      :status => :created, :location => @resource }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @resource.errors,
                      :status => :unprocessable_entity }
      end
    end
  end

  # PUT /resources/1
  # PUT /resources/1.xml
  def update
    @resource = Resource.find(params[:id])
    authorize! :edit, @resource

    respond_to do |format|
      if @resource.update_attributes(params[:resource])
        format.html { redirect_to(resources_path,
                      :notice => "#{@resource.name} successfully updated.") }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @resource.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /resources/1
  # DELETE /resources/1.xml
  def destroy
    @resource = Resource.find(params[:id])
    authorize! :destroy, @resource
    @resource.destroy

    respond_to do |format|
      format.html { redirect_to(resources_url) }
      format.xml  { head :ok }
    end
  end

  def toggle_active
    @resource = Resource.find(params[:id])
    authorize! :edit, @resource
    @resource.active = (not @resource.active)
    @resource.save!
    redirect_to resources_path
  end
end
