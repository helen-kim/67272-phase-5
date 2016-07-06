class StoresController < ApplicationController
  before_action :set_store, only: [:show, :edit, :update, :destroy]
  
  def index
    @active_stores = Store.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_stores = Store.inactive.alphabetical.paginate(page: params[:page]).per_page(10)  
  end

  def show
    if logged_in? && (current_user.role? :admin)
      @current_assignments = @store.assignments.current.by_employee.paginate(page: params[:page]).per_page(8)
    elsif logged_in? && (current_user.role? :manager)
      if (current_user.employee.current_assignment.store == @store)
        @current_assignments = @store.assignments.current.by_employee.paginate(page: params[:page]).per_page(8)
      end
    end
    fids = StoreFlavor.for_store(@store.id).map{|sf| sf.flavor_id}.compact
    @current_flavors = Flavor.active.map{|f| f if fids.include? f.id}.compact
    @store.get_store_coordinates
  end

  def new
    @store = Store.new
    @current_flavors = Flavor.active
    authorize! :new, @store
  end

  def edit
    @store = Store.find(params[:id])
    @current_flavors = Flavor.active
  end

  def create
    @store = Store.new(store_params)
    authorize! :create, @store
    if @store.save
      redirect_to store_path(@store), notice: "Successfully created #{@store.name}."
    else
      render action: 'new'
    end
  end

  def update
    if @store.update(store_params)
      redirect_to store_path(@store), notice: "Successfully updated #{@store.name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize! :destroy, @store
    @store.destroy
    redirect_to stores_path, notice: "Successfully removed #{@store.name} from the AMC system."
  end

  private
  def set_store
    @store = Store.find(params[:id])
  end

  def store_params
    params.require(:store).permit(:name, :street, :city, :state, :zip, :phone, :active, :flavor_ids => [])
  end

end