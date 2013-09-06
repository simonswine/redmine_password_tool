module PasswordInstancesHelper

  # Find password_instance_ids
  def find_password_instance
    @password_instance = PasswordInstance.find(params[:password_instance_id])
    if @password_instance.project != @project
      render_404
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_password_instances
    @password_instances = PasswordInstance.where(["project_id = ?", @project.id])
  end


  def password_instance_tree_options_for_select(password_instances, options = {})
    s = ''
    PasswordInstance.password_instance_tree(password_instances) do |password_instace, level|
      name_prefix = (level > 0 ? '&nbsp;' * 2 * level + '&#187; ' : '').html_safe
      tag_options = {:value => password_instace.id}
      if password_instace == options[:selected] || (options[:selected].respond_to?(:include?) && options[:selected].include?(password_instace))
        tag_options[:selected] = 'selected'
      else
        tag_options[:selected] = nil
      end
      tag_options.merge!(yield(password_instace)) if block_given?
      s << content_tag('option', "#{name_prefix}#{password_instace.name} (#{password_instace.password_template.name})".html_safe, tag_options)
    end
    s.html_safe
  end

  def parent_password_instance_select_tag(password_instance)
    if password_instance
      selected = password_instance.parent
    else
      selected = nil
    end

    options = ''
    options << "<option value=''>&lt;#{l(:label_pt_root)}&gt;</option>"
    options << password_instance_tree_options_for_select(@password_instances, :selected => selected)
    content_tag('select', options.html_safe, :name => 'parent_id', :id => 'password_instance_parent_id',:disabled => true)
  end




end