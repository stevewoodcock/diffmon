class JobsController < ApplicationController
  layout 'main'

  def index
    @jobs = Job.find(:all, :order => 'last_modified desc')
    respond_to do |format|
      format.html
      format.atom
    end
  end

  def show
    @job = Job.find(params[:id])
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(params[:job])
    if @job.save
      flash[:notice] = 'Job added'
      redirect_to jobs_url
    else
      render :action => :new
    end
  end

  def destroy
    @job = Job.find(params[:id])
    @job.destroy
    flash[:notice] = 'Job deleted'
    redirect_to jobs_url
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if @job.update_attributes(params[:job])
      flash[:notice] = 'Job updated'
      redirect_to @job
    else
      render :action => 'edit'
    end
  end

  def update_content
    @job = Job.find(params[:id])
    @job.update_content
    redirect_to @job
  end
end
