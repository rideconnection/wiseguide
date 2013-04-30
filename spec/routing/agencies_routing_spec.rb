require "spec_helper"

describe AgenciesController do
  describe "routing" do

    it "routes to #index" do
      get("/agencies").should route_to("agencies#index")
    end

    it "routes to #new" do
      get("/agencies/new").should route_to("agencies#new")
    end

    it "routes to #show" do
      get("/agencies/1").should route_to("agencies#show", :id => "1")
    end

    it "routes to #edit" do
      get("/agencies/1/edit").should route_to("agencies#edit", :id => "1")
    end

    it "routes to #create" do
      post("/agencies").should route_to("agencies#create")
    end

    it "routes to #update" do
      put("/agencies/1").should route_to("agencies#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/agencies/1").should route_to("agencies#destroy", :id => "1")
    end

  end
end
