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
    @jobs = Job.new
  end

end
