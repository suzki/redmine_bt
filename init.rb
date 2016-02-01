# coding: utf-8
require 'redmine'

Redmine::Plugin.register :redmine_bt do
  name 'Redmine Bootstrap 4 theme plugin'
  author 'Rubisel Prieto Dupeyrón'
  description 'This is a plugin modifying Redmine to use a Bootstrap 4 theme, based in plugin Bootstrap'
  version '0.0.1'
  url 'https://github.com/ruby232/redmine_bt'
  author_url 'https://github.com/ruby232/'
   
  requires_redmine :version_or_higher => '3.2.0'

  # remove help menu (it will be added later again)
  delete_menu_item(:top_menu, :help)

  # remove my page
  delete_menu_item(:top_menu, :my_page)
end

ActionDispatch::Callbacks.to_prepare do
  #require_dependency 'project'
  #require_dependency 'principal'

  ApplicationHelper.send(:include,  BTPlugin::ApplicationBTPatch)
  WelcomeController.send(:include,  BTPlugin::WelcomeControllerPatch)
  WatchersHelper.send(:include,  BTPlugin::WatchersBTPatch)


  #Redmine::MenuManager.map(:top_menu).push :time_entries, { :controller => 'timelog' }, :if => Proc.new { User.current.logged? }


end

require 'application_helper_patch'
require 'welcome_controller_patch'
require 'watchers_helper_patch'
require 'bootstrap_hooks'