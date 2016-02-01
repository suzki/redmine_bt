# encoding: utf-8

module BTPlugin
  module ApplicationBTPatch

    def self.included(base) # :nodoc:
      base.class_eval do
        alias_method_chain :javascript_heads, :bt
        alias_method_chain :render_flash_messages, :bt
        alias_method_chain :calendar_for, :bt
        alias_method_chain :error_messages_for, :bt
        alias_method_chain :delete_link, :bt
        alias_method_chain :progress_bar, :bt
      end
    end

    require 'helpers/font_awesome_helper'
    require 'helpers/menu_utility'
    require 'helpers/projects'
    require 'helpers/link_helper'
    require 'helpers/date'
    require 'helpers/filters'
    require 'helpers/form_helper'

    # Returns the javascript tags that are included in the html layout head
    def javascript_heads_with_bt
      tags = javascript_include_tag('jquery/jquery-2.2.0.min', :plugin => 'redmine_bt')
      tags << "\n".html_safe + javascript_include_tag('jquery-ui/jquery-ui.min', :plugin => 'redmine_bt')
      tags << "\n".html_safe + javascript_include_tag('jquery-ujs/rails', :plugin => 'redmine_bt')
      tags << "\n".html_safe + javascript_include_tag('application', :plugin => 'redmine_bt')
      unless User.current.pref.warn_on_leaving_unsaved == '0'
        tags << "\n".html_safe + javascript_tag("$(window).load(function(){ warnLeavingUnsaved('#{escape_javascript l(:text_warn_on_leaving_unsaved)}'); });")
      end
      tags
    end


    def render_flash_messages_with_bt
      s = ''
      flash.each do |k, v|
        if k == :notice
          k = 'success'
        end
        if k.to_s == 'error'
          k = 'danger'
        end
        close_botton = '<button type="button" class="close" data-dismiss="alert"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>'
        s << content_tag('div', close_botton.html_safe + v.html_safe, :class => "alert alert-#{k} alert-dismissible")
      end
      s.html_safe
    end

    def progress_bar_with_bt(pcts, options={})
      pcts = [pcts, pcts] unless pcts.is_a?(Array)
      pcts = pcts.collect(&:round)
      pcts[1] = pcts[1] - pcts[0]
      pcts << (100 - pcts[1] - pcts[0])
      legend = options[:legend] || ''
      type = 'danger'
      case
        when (pcts[0] > 25 and pcts[0] <= 50)
          type = 'warning'
        when (pcts[0] > 50 and pcts[0] <= 75)
          type = 'info'
        when (pcts[0] > 75 and pcts[0] <= 99)
          type = 'primary'
        when pcts[0]== 100
          type = 'success'

      end
      content_tag('progress',legend, :class => "progress progress-striped progress-#{type}",:value=>pcts[0],:max=>"100").html_safe
    end



  end
end