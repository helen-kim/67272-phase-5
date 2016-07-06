class ShiftJobsController < ApplicationController
  before_action :set_shiftjob, only: [:edit, :update, :destroy]

  def new
    @shiftjob = ShiftJob.new
  end

  def create
    @shiftjob = ShiftJob.new(shiftjob_params)
    if @shiftjob.save
      redirect_to shiftjobs_path, notice: "shiftjob has been created!"
    else
      render action: 'new'
    end
  end

  def update
    if @shiftjob.update(shiftjob_params)
      redirect_to shiftjobs_path, notice: "shiftjob has been updated!"
    else
      render action: 'edit'
    end
  end

  private
  def set_shiftjob
    @shiftjob = ShiftJob.find(params[:id])
  end

  def shiftjob_params
    params.require(:shiftjob).permit(:shift_id, :job_id)
  end
end