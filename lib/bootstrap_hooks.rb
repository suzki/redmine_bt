class BootstrapHooks < Redmine::Hook::ViewListener
  render_on(:view_layouts_base_html_head, :partial => 'hooks/css')
  render_on(:view_layouts_base_body_bottom, :partial => 'hooks/js')
end



