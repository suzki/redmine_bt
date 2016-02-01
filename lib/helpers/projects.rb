def project_logo(project)
  logo = File.join(Redmine::Utils.relative_url_root, 'plugin_assets', 'redmine_bt', 'images/logo_default.png')

  containers = [Project.includes(:attachments).
      references(:attachments).find(project.id)]

  containers.each do |container|
    next if container.attachments.empty?
    container.attachments.each do |file|
      if (file.filename == "logo.png")
        logo = url_for :controller => 'attachments', :action => 'download', :id => file.id
      end
    end
  end

  image_tag(logo, :class => 'pull-left', :size => "80x80", :alt => project.name)
end

def redmine_bt_spend_time(day=true)

  spent_on = 't' #para filtrar por el dia de hoy
  if not day
    spent_on = 'w' #para filtrar por esta semana
  end

  params = {:f => ["spent_on", "user_id", ""], :op => {"spent_on" => spent_on, "user_id" => "="}, :v => {"user_id" => ["me"]}, :c => ["hours"]}
  query = TimeEntryQuery.build_from_params(params, :name => '_')
  scope = query.results_scope().
      includes(:user)

  @user_total_hours = scope.sum(:hours).to_f

end