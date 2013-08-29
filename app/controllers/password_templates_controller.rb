
class PasswordTemplatesController < ApplicationController
  unloadable

  before_filter :find_password_template, :only => [:show, :form, :edit, :update]


  def index

  end

  def form
    respond_to do |format|
      format.js
    end
  end

  def set
  end

  def new

  end

  def show

  end

  # Find the password_template whose id is the :id parameter
  def find_password_template
    @password_template = PasswordTemplate.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end


end
