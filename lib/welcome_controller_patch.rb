module BTPlugin
  module WelcomeControllerPatch
    def self.included(base)
      base.class_eval do
        alias_method_chain :index, :bt
      end
    end

    def index_with_bt
      @projects = User.current.projects.active.select(:id, :name, :identifier, :lft, :rgt).to_a
    end

  end
end

