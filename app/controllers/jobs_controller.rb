class JobsController < ApplicationController
  before_action :set_job, only: [:edit, :update, :destroy]

  def index
    @active_jobs = Job.active.paginate(page:params[:page]).per_page(10)
    @inactive_jobs = Job.inactive.paginate(page: params[:page]).per_page(10)
  end

  def show 
  end

  def new
    @job = Job.new
  end

  def edit
  end

  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to jobs_path, notice: "Job has been created!"
    else
      render action: 'new'
    end
  end

  def update
    if @job.update(job_params)
      redirect_to jobs_path, notice: "Job has been updated!"
    else
      render action: 'edit'
    end
  end

  def destroy
    @job.destroy
    redirect_to jobs_path, notice: "Successfully removed job"
  end

  private
  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:name, :description, :active)
  end
end
