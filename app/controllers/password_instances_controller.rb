class PasswordInstancesController < ApplicationController

  include PasswordInstancesHelper

  default_search_scope :password_instances
  model_object PasswordInstance
  before_filter :find_project_by_project_id, :only => [:index, :new, :create]
  before_filter :find_model_object, :except => [:index, :new, :create]
  before_filter :find_project_from_association, :except => [:index, :new, :create]
  before_filter :authorize

  before_filter :find_password_instance, :except => [ :index, :new, :create]
  before_filter :find_password_instances, :only => [ :index, :new, :create, :edit, :update ]




  def safe_params

    output = {}

    ["password_template_id","parent_id","name"].each { |key|

      output[key] = params[key]

    }
    output['data_plain'] = JSON.generate(params['data'])


    output

  end


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

  def update
    @password_instance.update_attributes(params[:password_instance])
    @password_instance.data_plain = JSON.generate(params[:password_instance]['data'])

    if request.put? and @password_instance.save
      flash[:notice] = l(:notice_successful_update)
      redirect_to action: 'index', :project_id => @project.identifier
    else
      render :action => 'edit'
    end
  end

  # Delete @password_instance
  def destroy
    project_identifier = @password_instance.project.identifier
    @password_instance.destroy
    respond_to do |format|
      format.html { redirect_to action: 'index', :project_id => project_identifier}
      format.api  { render_api_ok }
    end
  end

  def create

    @password_instance = PasswordInstance.new (params[:password_instance])
    @password_instance.data_plain = JSON.generate(params[:password_instance]['data'])
    @password_instance.project = @project


    if @password_instance.save
      # Save succeed
      respond_to do |format|
        format.html {
          flash[:notice] = l(:notice_successful_create)
          redirect_to action: 'index'
        }
        format.api  { redirect_to action: 'index'}
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

    @password_instance = PasswordInstance.new



  end


end
