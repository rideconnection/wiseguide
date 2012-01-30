class HomeController < ApplicationController

  def index
    if current_user.is_outside_user then
      render :outside_dashboard
    end
  end
end
