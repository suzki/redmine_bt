module BTPlugin
  module WatchersBTPatch

    def self.included(base) # :nodoc:
      base.class_eval do
        alias_method_chain :watcher_link, :bt
      end
    end

    def watcher_link_with_bt(objects, user)
      return '' unless user && user.logged?
      objects = Array.wrap(objects)
      return '' unless objects.any?

      watched = Watcher.any_watched?(objects, user)
      text = watched ? fa_icon('fa-eye-slash') : fa_icon('fa-eye')
      url = watch_path(
          :object_type => objects.first.class.to_s.underscore,
          :object_id => (objects.size == 1 ? objects.first.id : objects.map(&:id).sort)
      )
      method = watched ? 'delete' : 'post'

      link_to text, url, :remote => true, :method => method,
              :class => 'btn btn-warning',
              :data => {:toggle => "tooltip", :placement => "bottom"},
              :title => watched ? l(:button_unwatch) : l(:button_watch)
    end
  end
end
