class FormFieldBuilder::LabelOnly < FormFieldBuilder::Decorated
  def form_field name_for_key, content, css_class, options={ }
    defaults = { required: false, id: nil }
    options = defaults.merge(options)
    label_node = build_label_node name_for_key, options
    "<#{tag} class='#{css_class}'>#{label_node}</#{tag}>".html_safe
  end

  def label name, options={ }
    build_form_field(name, options) { |*| "" }
  end
end
