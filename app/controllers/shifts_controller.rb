class ShiftsController < ApplicationController
  before_action :set_shift, only: [:edit, :update, :destroy, :start_shift, :end_shift]

  def index
    if params[:employee_id] || params[:assignment_id]
      @upcoming_shifts = Shift.upcoming.for_employee(params[:employee_id]).chronological.by_employee.paginate(page:params[:page]).per_page(10)
      @past_shifts = Shift.past.for_employee(params[:employee_id]).chronological.by_employee.paginate(page: params[:page]).per_page(10)
    elsif params[:shift_type] == "incomplete"
      @incomplete_shifts = Shift.incomplete.for_store(current_user.employee.current_assignment.store).chronological.paginate(page:params[:page]).per_page(10)
    elsif params[:shift_type] == "completed"
      @completed_shifts = Shift.completed.for_store(current_user.employee.current_assignment.store).chronological.paginate(page:params[:page]).per_page(10)
    elsif params[:shift_type] == "today"
      @today_shifts = Shift.today.for_store(current_user.employee.current_assignment.store).chronological.by_employee.paginate(page:params[:page]).per_page(10)
    elsif params[:shift_type] == "upcoming"
      @upcoming_shifts = Shift.upcoming.for_store(current_user.employee.current_assignment.store).chronological.by_employee.paginate(page:params[:page]).per_page(10)
    elsif params[:shift_type] == "past"  
      @past_shifts = Shift.past.for_store(current_user.employee.current_assignment.store).chronological.by_employee.paginate(page: params[:page]).per_page(10)
    else
      # @upcoming_shifts = Shift.upcoming.for_store(current_user.employee.current_assignment.store).chronological.by_employee.paginate(page:params[:page]).per_page(10)
      @today_shifts = Shift.today.for_store(current_user.employee.current_assignment.store).chronological.by_employee.paginate(page:params[:page]).per_page(10) 
      # @past_shifts = Shift.past.for_store(current_user.employee.current_assignment.store).chronological.by_employee.paginate(page: params[:page]).per_page(10)
    end
  end

  def show 
    @shift = Shift.find(params[:id])
    sjs = ShiftJob.for_shift(@shift.id).map{|sj| sj.job_id}.compact
    @jobs = Job.active.map{|j| j if sjs.include? j.id}.compact 
  end

  def new
    @shift = Shift.new
    @jobs = Job.active
  end

  def edit
    @jobs = Job.active
  end

  def create
    @shift = Shift.new(shift_params)
    if @shift.save
      fomat.html {redirect_to shifts_path, notice: "Shift has been created!"}
    else
      render action: 'new'
    end
  end

  def start_shift  
    @shift.start_now
    @shift.save
    redirect_to home_path, notice: "#{@shift.assignment.employee.proper_name}'s shift at #{@shift.assignment.store.name} is started."
  end

  def end_shift 
    @shift.end_now
    @shift.save
    redirect_to home_path, notice: "#{@shift.assignment.employee.proper_name}'s shift at #{@shift.assignment.store.name} has ended."    
  end

  def update
    if @shift.update(shift_params)
      redirect_to shift_path(@shift), notice: "Shift has been updated!"
    else
      render action: 'edit'
    end
  end

  def destroy
    @shift.destroy
    redirect_to :back, notice: "Successfully removed shift"
  end

  private
  def set_shift
    @shift = Shift.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:assignment_id, :date, :start_time, :end_time, :notes, :job_ids => [])
  end
end
