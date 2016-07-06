class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, notice: "user has been created!"
    else
      render action: 'new'
    end
  end

  def update
    if @user.update(user_params)
      redirect_to users_path, notice: "user has been updated!"
    else
      render action: 'edit'
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
      if current_user && current_user.role?(:admin)
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :role, :active)  
      else
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :active)
      end
    end
end
end
