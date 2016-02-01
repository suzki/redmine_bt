def error_messages_for_with_bt(*objects)
  html = ""
  objects = objects.map {|o| o.is_a?(String) ? instance_variable_get("@#{o}") : o}.compact
  errors = objects.map {|o| o.errors.full_messages}.flatten
  if errors.any?
    html << "<div id='errorExplanation'>\n"
    errors.each do |error|
      html << "<div class='alert alert-danger' role='alert'>#{h error}</div>\n"
    end
    html << "</div>\n"
  end
  html.html_safe
end
