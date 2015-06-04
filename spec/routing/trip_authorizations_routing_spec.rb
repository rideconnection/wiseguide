require 'rails_helper'

RSpec.describe TripAuthorizationsController do
  describe "routing" do

    it "routes to #index" do
      get("/trip_authorizations").should route_to("trip_authorizations#index")
    end

    it "routes to #new" do
      get("/trip_authorizations/new").should route_to("trip_authorizations#new")
    end

    it "routes to #show" do
      get("/trip_authorizations/1").should route_to("trip_authorizations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/trip_authorizations/1/edit").should route_to("trip_authorizations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/trip_authorizations").should route_to("trip_authorizations#create")
    end

    it "routes to #update" do
      put("/trip_authorizations/1").should route_to("trip_authorizations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/trip_authorizations/1").should route_to("trip_authorizations#destroy", :id => "1")
    end

    it "routes to #complete_disposition" do
      put("/trip_authorizations/1/complete_disposition").should route_to("trip_authorizations#complete_disposition", :id => "1")
    end

  end
end
