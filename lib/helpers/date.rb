def calendar_for_with_bt(field_id)
  include_calendar_headers_tags_bt
  javascript_tag("$(function() { $('##{field_id}').addClass('date').datepicker(datepickerOptions); });")
end

def include_calendar_headers_tags_bt
  unless @calendar_headers_tags_included
    tags = ''.html_safe
    @calendar_headers_tags_included = true
    content_for :header_tags do
      start_of_week = Setting.start_of_week
      start_of_week = l(:general_first_day_of_week, :default => '1') if start_of_week.blank?
      start_of_week = start_of_week.to_i % 7
      tags << javascript_tag(
          "var datepickerOptions={dateFormat: 'yy-mm-dd', firstDay: #{start_of_week}, " +
              "showOn: 'focus', buttonImageOnly: false, showButtonPanel: false, showWeek: false, showOtherMonths: true, " +
              "selectOtherMonths: true, changeMonth: true, changeYear: true, " +
              "beforeShow: beforeShowDatePicker};")
      tags
    end
  end
end