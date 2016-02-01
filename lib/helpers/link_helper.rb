def delete_link_with_bt(url, options={})
  options = {
      :method => :delete,
      :data => {:confirm => l(:text_are_you_sure)},
      :class => 'btn btn-danger'
  }.merge(options)

  link_to label_with_icon(l(:button_delete),"fa-trash"), url, options
end