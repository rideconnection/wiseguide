class AssessmentRequestsController < ApplicationController
  load_and_authorize_resource

  # GET /assessment_requests
  # GET /assessment_requests.xml
  def index
    @assessment_requests = AssessmentRequest.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assessment_requests }
    end
  end

  # GET /assessment_requests/1
  # GET /assessment_requests/1.xml
  def show
    @assessment_request = AssessmentRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @assessment_request }
    end
  end

  # GET /assessment_requests/new
  # GET /assessment_requests/new.xml
  def new
    @assessment_request = AssessmentRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @assessment_request }
    end
  end

  # GET /assessment_requests/1/edit
  def edit
    @assessment_request = AssessmentRequest.find(params[:id])
  end

  # POST /assessment_requests
  # POST /assessment_requests.xml
  def create
    fields = params[:assessment_request]
    fields[:submitter] = current_user
    @assessment_request = AssessmentRequest.new(fields)

    respond_to do |format|
      if @assessment_request.save
        format.html { redirect_to(@assessment_request, :notice => 'Assessment request was successfully created.') }
        format.xml  { render :xml => @assessment_request, :status => :created, :location => @assessment_request }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @assessment_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /assessment_requests/1
  # PUT /assessment_requests/1.xml
  def update
    @assessment_request = AssessmentRequest.find(params[:id])

    respond_to do |format|
      if @assessment_request.update_attributes(params[:assessment_request])
        format.html { redirect_to(@assessment_request, :notice => 'Assessment request was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @assessment_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /assessment_requests/1
  # DELETE /assessment_requests/1.xml
  def destroy
    @assessment_request = AssessmentRequest.find(params[:id])
    @assessment_request.destroy

    respond_to do |format|
      format.html { redirect_to(assessment_requests_url) }
      format.xml  { head :ok }
    end
  end
end
