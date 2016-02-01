def render_dropdown_menu(menu, project=nil)
  links = []
  menu_items_for(menu, project) do |node|
    caption, url, selected = extract_node_details(node, project)
    links << link_to(h(caption), url, :class => "dropdown-item" + (selected ? ' active' : ''))
  end
  links.empty? ? nil : links.join("\n").html_safe
end

def render_nav(menu, html_class='', project=nil)
  links = []
  menu_items_for(menu, project) do |node|
    caption, url, selected = extract_node_details(node, project)
    links << link_to(h(caption), url, :class => "nav-item nav-link" + (selected ? ' active' : ''))
  end
  html_class = 'nav ' + html_class
  links.empty? ? nil : content_tag('nav', links.join("\n").html_safe, :class => html_class)
end

# Renders the project quick-jump box
def render_project_dropdown
  return unless User.current.logged?
  projects = User.current.projects.active.select(:id, :name, :identifier, :lft, :rgt).to_a
  if projects.any?
    content = content_tag('button', l(:label_jump_to_a_project), :class => 'dropdown-toggle', :type => "button", :id => "project-menu",
                          :data => {:toggle => "dropdown", :haspopup => "true"}, :"aria-expanded" => "false")
    links = []
    projects.each do |project|
      links << link_to(project.name,
                       {:controller => 'projects', :action => 'show', :id => project.id},
                       :class => 'dropdown-item')
    end
    content += content_tag('div', links.join("\n").html_safe, :class => 'dropdown-menu', :"aria-labelledby" => 'project-menu')
    content_tag('div', content, :class => 'dropdown pull-xs-right')
  end
end

def render_main_menu_bt(project)
  render_tabs_menu((project && !project.new_record?) ? :project_menu : :application_menu, project, "nav-justified")
end

def render_tabs_menu(menu, project=nil, classes=nil)
  links = []
  menu_items_for(menu, project) do |node|
    caption, url, selected = extract_node_details(node, project)
    links << content_tag('li', link_to(h(caption), url, :class => "nav-link" + (selected ? ' active' : '')), :class => 'nav-item')
  end
  classes = "nav nav-tabs " + classes
  links.empty? ? nil : content_tag('ul', links.join("\n").html_safe, :class => classes)
end

def pagination_links_full_bt(*args)
  pagination_links_each_bt(*args) do |text, parameters, options|
      if block_given?
        yield text, parameters, options
      else
        link_to text, params.merge(parameters), options
      end
    end
  end

def pagination_links_each_bt(paginator, count=nil, options={}, &block)
    options.assert_valid_keys :per_page_links

    per_page_links = options.delete(:per_page_links)
    per_page_links = false if count.nil?
    page_param = paginator.page_param

    html = '<nav class="pull-left"><ul class="pagination">'
    if paginator.previous_page
      text = "\xc2\xab "
      html << content_tag('li',
                          link_to(text, {page_param => paginator.previous_page},:class => 'page-link',
                              :accesskey => accesskey(:previous)),
                          :class => 'page-item previous page')
    end

    previous = nil
    paginator.linked_pages.each do |page|
      if previous && previous != page - 1
        html << content_tag('li', content_tag('a', '&hellip;'.html_safe,:class => 'page-link'), :class => 'page-item spacer')
      end
      if page == paginator.page
        html << content_tag('li', content_tag('a', page.to_s,:class => 'page-link'), :class => 'page-item active')
      else
        html << content_tag('li',
                            link_to(page.to_s, {page_param => page},:class => 'page-link'),
                            :class => 'page-item page')
      end
      previous = page
    end

    if paginator.next_page
      # \xc2\xbb(utf-8) = &#187;
      text = " \xc2\xbb"
      html << content_tag('li',
                          link_to(text, {page_param => paginator.next_page},:class => 'page-link',
                              :accesskey => accesskey(:next)),
                          :class => 'page-item next page')
    end
    html << '</ul></nav>'

    info = ''.html_safe
    info << content_tag('span', "(#{paginator.first_item}-#{paginator.last_item}/#{paginator.item_count})", :class => 'items') + ' '
    if per_page_links != false && links = per_page_links(paginator, &block)
      info << content_tag('span', links.to_s, :class => 'per-page')
    end
    html << content_tag('span', info,:class => 'pull-right')

    ('<div class="row"><div class="col-lg-12 col-md-12">'+html+'</div></div>').html_safe
  end
