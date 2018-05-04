class FormFieldBuilder::Plain < FormFieldBuilder::Base
  def build_form_field name, options={ }
    yield(field_name_for(name, options), value_for_field(name, options)).html_safe
  end
end
