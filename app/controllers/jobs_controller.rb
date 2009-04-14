class JobsController < ApplicationController
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

end