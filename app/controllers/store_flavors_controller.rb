class StoreFlavorsController < ApplicationController
  before_action :set_storeflavor, only: [:edit, :update, :destroy]

  def new
    @storeflavor = StoreFlavor.new
  end

  def create
    @storeflavor = StoreFlavor.new(storeflavor_params)
    if @storeflavor.save
      redirect_to storeflavors_path, notice: "storeflavor has been created!"
    else
      render action: 'new'
    end
  end

  def update
    if @storeflavor.update(storeflavor_params)
      redirect_to storeflavors_path, notice: "storeflavor has been updated!"
    else
      render action: 'edit'
    end
  end

  private
  def set_storeflavor
    @storeflavor = StoreFlavor.find(params[:id])
  end

  def storeflavor_params
    params.require(:storeflavor).permit(:store_id, :flavor_id)
  end
end