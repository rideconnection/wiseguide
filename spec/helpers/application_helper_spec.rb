require 'spec_helper'

describe ApplicationHelper do
  describe "last_updated" do
    before do
      @object = FactoryGirl.create(:user)
    end

    it "should return the date the object was last updated" do
      helper.last_updated(@object).should include "Last updated #{@object.updated_at.to_s(:long)}"
    end

    with_versioning do
      before do
        @editor = FactoryGirl.create(:user)
        PaperTrail.whodunnit = @editor.id
      end
      
      it "should include the display_name of the user who last updated the object when an :update version is present" do
        @object.update_attribute :last_name, 'Edit 1'
        helper.last_updated(@object).should include " by #{@editor.display_name}"
      end
    end
  end

  describe "creation_stamp" do
    it "should return the date the object was created" do
      object = FactoryGirl.create(:user)
      helper.creation_stamp(object).should include "Created on #{object.created_at.to_s(:long)}"
    end

    with_versioning do
      before do
        @creator = FactoryGirl.create(:user)
        PaperTrail.whodunnit = @creator.id
      end

      it "should include the display_name of the user who created the object when a :create version is present" do
        object = FactoryGirl.create(:user)
        helper.creation_stamp(object).should include " by #{@creator.display_name}"
      end
    end
  end
end
