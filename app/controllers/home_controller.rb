class HomeController < ApplicationController

  def home
    if logged_in?
      # get my assignments
      @current_assignment = current_user.employee.current_assignment
      @past_assignments = current_user.employee.assignments.past
      
      if !@current_assignment.nil?
        @store = Store.find_by_id(@current_assignment.store_id)
        if current_user.role? :manager
        # get my upcoming shifts
          @upcoming_shifts = Shift.upcoming.for_store(@current_assignment.store_id).chronological.paginate(page: params[:today]).per_page(5)
          
          # get my past shifts
          @past_shifts = Shift.past.for_store(@current_assignment.store_id).chronological
          @incomplete_shifts = Shift.incomplete.for_store(@current_assignment.store_id).chronological.paginate(page: params[:incomplete]).per_page(5)
          @today_shifts = Shift.today.for_store(@current_assignment.store_id).chronological.paginate(page: params[:today]).per_page(5)
        elsif current_user.role? :employee
          @upcoming_shifts = Shift.upcoming.for_employee(@current_assignment.employee).chronological.paginate(page: params[:today]).per_page(5)
          
          # get my past shifts
          @past_shifts = Shift.past.for_employee(@current_assignment.employee).chronological
          @today_shifts = Shift.today.for_employee(@current_assignment.employee).chronological.paginate(page: params[:today]).per_page(5)
        end
      end
    end
  end

  def about
  end

  def privacy
  end

  def contact
  end

  def splash
  end
  
end