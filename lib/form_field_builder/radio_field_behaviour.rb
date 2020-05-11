module FormFieldBuilder::RadioFieldBehaviour
  def generate_id *items ; items.map(&:to_s).join("_") ; end

  def _make_yes_no_any name, yes_sel, no_sel, any_sel, values, options
    "<div class='yes_no_any'>
       #{hidden name, options}
       <div class='option_container'>
         <div class='option yes value-#{values[0]} #{yes_sel}'>#{i18n.t "ffb.yes"}</div>
         <div class='option no  value-#{values[1]} #{no_sel}' >#{i18n.t "ffb.no" }</div>
         <div class='option any value-#{values[2]} #{any_sel}'>#{i18n.t "ffb.all"}</div>
       </div>
     </div>".html_safe
  end

  def yes_no_any name, options={ }
    build_form_field(name, options) { |field_name, value|
      yes_sel = same_truth?(value, true )       ? "selected" : ""
      no_sel  = same_truth?(value, false)       ? "selected" : ""
      any_sel = (value.blank? && no_sel.blank?) ? "selected" : ""
      _make_yes_no_any name, yes_sel, no_sel, any_sel, ["true", "false", "nil"], options
    }
  end

  def yes_default_no_any name, options={ }
    build_form_field(name, options) { |field_name, value|
      yes_sel = same_truth?(value, true )        ? "selected" : ""
      any_sel = same_truth?(value, false)        ? "selected" : ""
      no_sel  = (value.blank? && any_sel.blank?) ? "selected" : ""
      _make_yes_no_any name, yes_sel, no_sel, any_sel, ["true", "nil", "false"], options
    }
  end

  def yes_no name, options={ }
    build_form_field(name, options) { |field_name, value|
      yes_selected = same_truth?(value, true ) ? "selected" : ""
      no_selected  = same_truth?(value, false) ? "selected" : ""

      "<div class='yes_no_any'>
         #{ hidden name, options }
         <div class='option_container'>
           <div class='option yes value-true  #{yes_selected}'>#{i18n.t "ffb.yes"}</div>
           <div class='option no  value-false #{no_selected}' >#{i18n.t "ffb.no" }</div>
         </div>
       </div>".html_safe
    }
  end

  def boolean name, options={ }
    radio name, [[true, i18n.t("ffb.yes")],[false, i18n.t("ffb.no")]], options
  end

  def radio name, choices, options={ }
    build_form_field(name, options) { |field_name, value|
      raw_radio field_name, parameterise(value), choices, options
    }
  end

  def all_radio name, choices, options={ }
    radio name, prepend_all(choices), options
  end

  def i18n_radio name, key, options={ }
    radio name, select_options_from_i18n(key, options), options
  end

  def object_radio name, objects, presentation_method, options={ }
    radio name, selectify(objects, presentation_method), options
  end

  def all_i18n_radio name, key, options={ }
    radio name, prepend_all(select_options_from_i18n(key, options)), options
  end

  private

  def same_truth? v, bool
    v == bool || v.to_s.as_bool == bool
  end

  def prepend_all choices
    ([[nil, i18n.t("ffb.all")]] + choices)
  end

  def raw_radio field_name, value, choices, options
    choices_html = choices.map { |choice|
      radio_option field_name, choice[0], choice[1], value, options
    }.join

    "<div class='radio_container'>#{choices_html}</div>".html_safe
  end

  def radio_option field_name, choice_value, choice_label, field_value, options
    radio_id = generate_id field_name, choice_value, options[:id]
    checked = ("#{field_value}".eql?("#{choice_value}"))
    radio_input           = mk_radio_option radio_id, field_name, choice_value, checked
    label_for_radio       = mk_label radio_id, choice_label
    description_for_radio = mk_description radio_id, choice_label
    ["<div class='radio-option'>", radio_input, label_for_radio, description_for_radio, "</div>"].join.html_safe
  end

  def mk_radio_option input_id, field_name, choice_value, checked
    checked_attr = checked ? " checked='checked'" : ""
    "<input id='#{input_id}' type='radio' name='#{field_name}' value='#{h choice_value}'#{checked_attr}>"
  end

  def mk_description input_id, txt
    return nil unless txt.is_a?(Hash) && txt.key?(:description)
    "<span class='description'> - #{h txt[:description]}</span>".html_safe
  end

  def mk_label input_id, txt
    txt = (txt.is_a? Hash) ? txt[:label] : txt
    "<label for='#{input_id}'>#{h txt}</label>".html_safe
  end
end
