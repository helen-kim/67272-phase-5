class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # admin rights
    if user.role? :admin
      can :manage, :all

    # manager rights
    elsif user.role? :manager
      # read active store, job, flavor data
      can :read, Store, :active => true
      can :read, Job, :active => true
      can :read, Flavor, :active => true
      # read employee info for employees at same store
      can :read, Employee do |this_employee|
        my_store = user.employee.current_assignment.store_id
        this_employee.current_assignment.store_id == my_store
      end
      # read current assignments of employees at same store
      can :read, Assignment do |this_assignment|
        my_store = user.employee.current_assignment.store_id
        current_assignments = Assignment.current.map{|a| a.id if a.store_id == my_store}
        current_assignments.include? this_assignment.id
      end
      # read shift info for employees at same store
      can :read, Shift do |this_shift|
        my_store = user.employee.current_assignment.store_id
        shifts = Assignment.current.map{|a| a.shifts.map(&:id) if a.store_id == my_store}.flatten
        shifts.include? this_shift.id
      end
      # create new shifts for employees at same store
      can :create, Shift do |this_shift|
        my_store = user.employee.current_assignment.store_id
        shifts = Assignment.current.map{|a| a.shifts.map(&:id) if a.store_id == my_store}.flatten
        shifts.include? this_shift.id
      end
      # update shifts at same store
      can :update, Shift do |this_shift|
        my_store = user.employee.current_assignment.store_id
        shifts = Assignment.current.map{|a| a.shifts.map(&:id) if a.store_id == my_store}.flatten
        shifts.include? this_shift.id
      end
      # destroy shifts at same store
      can :destroy, Shift do |this_shift|
        my_store = user.employee.current_assignment.store_id
        shifts = Assignment.current.map{|a| a.shifts.map(&:id) if a.store_id == my_store}.flatten
        shifts.include? this_shift.id
      end
      # create shiftjobs for shifts at same store
      can :create, ShiftJob do |this_shiftjob|
        my_store = user.employee.current_assignment.store_id
        this_shiftjob.shift.assignment.store_id == my_store
      end
      # destroy shiftjobs for shifts at same store
      can :destroy, ShiftJob do |this_shiftjob|
        my_store = user.employee.current_assignment.store_id
        this_shiftjob.shift.assignment.store_id == my_store
      end
      # create storeflavors at same store
      can :create, StoreFlavor do |this_storeflavor|
        my_store = user.employee.current_assignment.store_id  
        my_store == this_storeflavor.store_id
      end
      # destroy storeflavors at same store
      can :destroy, StoreFlavor do |this_storeflavor|
        my_store = user.employee.current_assignment.store_id  
        my_store == this_storeflavor.store_id
      end

      # read own user profile
      can :read, User do |u|
        u.id == user.id
      end
      # update own user profile
      can :update, User do |u|
        u.id == user.id
      end
      # read own employee data
      can :read, Employee do |e|
        e.id == user.employee.id
      end
      # update own employee data
      can :update, Employee do |e|
        e.id == user.employee.id
      end

    # employee rights
    elsif user.role? :employee
      # read active store, job, flavor data
      can :read, Store, :active => true
      can :read, Job, :active => true
      can :read, Flavor, :active => true
      # read own assignment data
      can :read, Assignment do |this_assignment|
        my_assignmnets = user.employee.assignments.map(&:id)
        my_assignmnets.include? this_assignment.id
      end
      # read own shift data
      can :read, Shift do |this_shift|
        my_shifts = user.employee.shifts.map(&:id)
        my_shifts.include? this_shift.id 
      end
      # read own shiftjob data
      can :read, ShiftJob do |this_shiftjob|
        shift_jobs = user.employee.shifts.map{|s| s.shiftjobs.map(&:id)}.flatten
        shift_jobs.include? this_shiftjob.id
      end
      # read own user profile
      can :read, User do |u|
        u.id == user.id
      end
      # update own user profile
      can :update, User do |u|
        u.id == user.id
      end
      # read own employee data
      can :read, Employee do |e|
        e.id == user.employee.id
      end
      # update own employee data
      can :update, Employee do |e|
        e.id == user.employee.id
      end

    # guest rights
    else
      can :read, Store, :active => true
    end
  end
end
