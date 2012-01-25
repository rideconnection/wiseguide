class AdminController < ApplicationController
  def users
    authorize! :read, User
    @users = User.all
  end

  def index

  end
end
