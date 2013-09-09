module PasswordInstancesHelper

  # Find password_instance_ids
  def find_password_instance
    @password_instance = PasswordInstance.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_password_instances
    @password_instances = PasswordInstance.where(["project_id = ?", @project.id])
  end


  def password_instance_tree_options(password_instances)
    s = [["<#{l(:label_pt_root)}>",nil]]
    PasswordInstance.password_instance_tree(password_instances) do |password_instance, level|
      name_prefix = (level > 0 ? '&nbsp; ' * 2 * level + '&#187; ' : '').html_safe
      tag_options = {:value => password_instance.id}
      s << ["#{name_prefix}#{password_instance.name} (#{password_instance.password_template.name})".html_safe, password_instance.id]
    end
    s
  end





end