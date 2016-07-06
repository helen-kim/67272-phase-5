class FlavorsController < ApplicationController
  before_action :set_flavor, only: [:edit, :update, :destroy]

  def index
    @active_flavors = Flavor.active.paginate(page:params[:page]).per_page(10)
    @inactive_flavors = Flavor.inactive.paginate(page: params[:page]).per_page(10)
  end

  def show 
  end

  def new
    @flavor = Flavor.new
  end

  def edit
  end

  def create
    @flavor = Flavor.new(flavor_params)
    if @flavor.save
      redirect_to flavors_path, notice: "Flvaor has been created!"
    else
      render action: 'new'
    end
  end

  def update
    if @flavor.update(flavor_params)
      redirect_to flavors_path, notice: "Flavor has been updated!"
    else
      render action: 'edit'
    end
  end

  def destroy
    @flavor.destroy
    redirect_to flavors_path, notice: "Successfully removed flavor"
  end

  private
  def set_flavor
    @flavor = Flavor.find(params[:id])
  end

  def flavor_params
    params.require(:flavor).permit(:name, :active)
  end
end