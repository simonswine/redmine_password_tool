
class PasswordInstancesController < ApplicationController
  unloadable

  before_filter :find_project
  
  def index

    @password_instances = PasswordInstance.all #.find(project_id: @project.id)

  end

  def set
  end

  def new

    if params.has_key? "commit"

      # Check sent template id
      @template = PasswordTemplate.find_by_id(params[:passwort_template_id])

      # TODO Do save better
      @password_instance = PasswordInstance.new()
      @password_instance.project = @project
      @password_instance.data = JSON.generate(params[:data])
      @password_instance.password_template = @template
      @password_instance.name = params[:name]

      if @password_instance.save
        params={}
      end

    end

  end


end
