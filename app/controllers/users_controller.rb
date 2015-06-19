require 'new_user_mailer'

class UsersController < Devise::SessionsController
  # GET sign_in
  def new
    if User.count == 0
      return redirect_to action: :show_init
    end

    @user = User.new
  end

  def new_user
    if User.count == 0
      return redirect_to :init
    end
    authorize! :edit, User
    @user = User.new
  end

  def create_user
    authorize! :edit, User
    
    params[:user][:password] = params[:user][:password_confirmation] = User.random_password
    @user = User.new(user_params)

    if @user.save
      NewUserMailer.new_user_email(@user, @user.password).deliver
      flash[:notice] = "#{@user.email} has been added and a password has been emailed"
      redirect_to users_path
    else
      flash[:notice] = "Could not create user"
      render action: :new_user
    end
  end

  # GET /edit_user?id=x
  def edit
    @user = User.find(params[:id])
    authorize! :edit, @user
  end

  # PUT /update_user_details
  def update_details
    @user = User.find(params[:id])
    authorize! :edit, @user
    @user.update_attributes!(user_params)
    flash[:notice] = "#{@user.display_name}'s record has been updated"
    redirect_to users_path
  end

  # POST /update_user
  def update
    @user = User.find(params[:id])
    authorize! :edit, @user
    @user.level = params[:user][:level]
    @user.save
    flash[:notice] = "#{@user.display_name}'s role has been changed"
    redirect_to users_path
  end

  def show_change_password; end

  def change_password
    if current_user.update_password(change_password_params)
      sign_in(current_user, bypass: true)
      flash[:notice] = "Password changed"
      redirect_to root_path
    else
      flash.now[:alert] = "Error updating password"
      render action: :show_change_password
    end
  end

  def show_init
    #create initial user
    if User.count > 0
      return redirect_to action: :new
    end
    @user = User.new
  end


  def init
    if User.count > 0
      return redirect_to action: :new
    end
    @user = User.new user_params
    @user.level = 100
    @user.save!

    flash[:notice] = "OK, now sign in"
    redirect_to action: :new
  end
  
  def sign_out
    if current_user
      scope = Devise::Mapping.find_scope!(current_user)
      current_user = nil
      warden.logout(scope)
    end

    return redirect_to "/"
  end

  def delete
    @user = User.find(params[:id])
    authorize! :manage, @user
    @user.level = -1
    @user.encrypted_password = "x"
    @user.save!
    redirect_to :users, notice: "User #{@user.email} successfully marked deleted."
  end
  
  private
  
  def user_params
    params.require(:user).permit(
      :email,
      :first_name,
      :last_name,
      :level,
      :organization_id,
      :password,
      :password_confirmation,
      :phone_number,
    )
  end
  
  def change_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
