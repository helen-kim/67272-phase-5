class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:edit, :update, :destroy]
  # before_action :set_assignment, only: [:show, :edit, :update, :destroy]

  def index
    if params[:assn_type] == "current"
      @current_assignments = Assignment.current.by_store.by_employee.chronological.paginate(page: params[:page]).per_page(15)
      authorize! :read, @current_assignments
    elsif params[:assn_type] == "past"
      @past_assignments = Assignment.past.by_employee.by_store.paginate(page: params[:page]).per_page(15)  
      authorize! :read, @past_assignments
    else
      @current_assignments = Assignment.current.by_store.by_employee.chronological.paginate(page: params[:page]).per_page(15)
      @past_assignments = Assignment.past.by_employee.by_store.paginate(page: params[:page]).per_page(15)  
    end 
  end

  def show
    @assignment = current_user.employee.current_assignment
    @shifts = Shift.all.for_employee(@assignment.employee).chronological.paginate(page: params[:page]).per_page(10)
  end

  def new
    @assignment = Assignment.new
    authorize! :new, @assignment
  end

  def edit
  end

  def create
    @assignment = Assignment.new(assignment_params)
    authorize! :create, @assignment
    if @assignment.save
      redirect_to assignments_path, notice: "#{@assignment.employee.proper_name} is assigned to #{@assignment.store.name}."
      # redirect_to assignment_path(@assignment), notice: "#{@assignment.employee.proper_name} is assigned to #{@assignment.store.name}."
    else
      render action: 'new'
    end
  end

  def update
    authorize! :update, @assignment
    if @assignment.update(assignment_params)
      redirect_to assignments_path, notice: "#{@assignment.employee.proper_name}'s assignment to #{@assignment.store.name} is updated."
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize! :destroy, @assignment
    @assignment.destroy
    redirect_to assignments_path, notice: "Successfully removed #{@assignment.employee.proper_name} from #{@assignment.store.name}."
  end

  private
  def set_assignment
    @assignment = Assignment.find(params[:id])
  end

  def assignment_params
    params.require(:assignment).permit(:employee_id, :store_id, :start_date, :end_date, :pay_level)
  end

end