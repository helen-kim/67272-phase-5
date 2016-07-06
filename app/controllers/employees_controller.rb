class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  
  def index
    if current_user.role? :admin
      @active_employees = Employee.active.alphabetical.paginate(page: params[:page]).per_page(10)
      @inactive_employees = Employee.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
    elsif current_user.role? :manager
      @active_employees = Employee.for_store(current_user.employee.current_assignment.store_id).active.alphabetical.paginate(page: params[:page]).per_page(10)
      @inactive_employees = Employee.for_store(current_user.employee.current_assignment.store_id).inactive.alphabetical.paginate(page: params[:page]).per_page(10)
    end
  end

  def show
    # get the assignment history for this employee
    @assignments = @employee.assignments.chronological.paginate(page: params[:page]).per_page(5)
    # get upcoming shifts for this employee (later)  
    # authorize! :read, @assignments
    @todays_shifts = @employee.shifts.today.chronological.paginate(page: params[:upcoming]).per_page(5)
    @upcoming_shifts = @employee.shifts.upcoming.chronological.paginate(page: params[:upcoming]).per_page(5)
    @past_shifts = @employee.shifts.past.chronological.paginate(page: params[:past]).per_page(5)
  end

  def new
    @employee = Employee.new
    @employee.build_user
    authorize! :new, @employee
  end

  def edit
    @employee = Employee.find(params[:id])
    
  end

  def create
    @employee = Employee.new(employee_params)
    authorize! :create, @employee
    if @employee.save
      redirect_to @employee, notice: "Successfully created #{@employee.proper_name}."
    else
      render action: 'new'
    end
  end

  def update
    authorize! :update, @employee
    if @employee.update(employee_params)
      redirect_to employee_path(@employee), notice: "Successfully updated #{@employee.proper_name}."
    else
      render action: 'edit'
    end
  end

  def destroy
    authorize! :destroy, @employee
    @employee.destroy
    redirect_to employees_path, notice: "Successfully removed #{@employee.proper_name} from the AMC system."
  end

  private
  def set_employee
    @employee = Employee.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :ssn, :date_of_birth, :role, :phone, :active, user_attributes: [:id, :email, :password, :password_confirmation, :_destroy])
  end

end