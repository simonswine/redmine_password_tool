
class PasswordInstancesController < ApplicationController
  unloadable

  include PasswordInstancesHelper


  before_filter :find_project
  before_filter :find_password_instance, :except => [ :index, :new, :create]
  before_filter :find_password_instances, :only => [ :index, :new, :create ]


  def index

  end

  def set
  end


  # Show @password_instance
  def show

  end

  # Show @password_instance's data_schema
  def data_schema



  end


  # Edit @password_instance
  def edit

  end

  # Delete @password_instance
  def destroy
    @password_instance.destroy
    respond_to do |format|
      format.html { redirect_to action: 'index' }
      format.api  { render_api_ok }
    end
  end

  def create

    @password_instance = PasswordInstance.new

    password_instance_params(params)

    if @password_instance.save
      # Save succeed
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_create)
          redirect_to action: 'index'
        }
        format.api  { redirect_to action: 'index' }
      end
    else
      # Validation error
      respond_to do |format|
        format.html { render :action => 'new'}
        format.api  { render_validation_errors(@password_instance) }
      end
    end
  end




  def new



  end


end
