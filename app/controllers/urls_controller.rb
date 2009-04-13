class UrlsController < ApplicationController
  def index
    @urls = Url.find(:all, :order => 'last_modified desc')
    respond_to do |format|
      format.html
      format.atom
    end
  end
end