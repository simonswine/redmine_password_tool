
class PasswordInstancesController < ApplicationController
  unloadable

  before_filter :find_project
  
  def index
    @project_identifier = params[:id]
    @project = Project.find(params[:id])
  end

  def set
  end

  def new

    @templates = PasswordTemplate.find(:all, :order => "name")


  end


end
