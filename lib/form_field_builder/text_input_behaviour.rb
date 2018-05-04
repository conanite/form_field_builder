require "action_view/helpers/number_helper"

module FormFieldBuilder::TextInputBehaviour
  include ::ActionView::Helpers::NumberHelper

  def show_decimal amount, fractionals=1 ; number_with_precision amount, precision: fractionals, significant: false ; end
  def show_integer amount                ; show_decimal amount, 0                                                   ; end
  def web_date                         d ; (i18n.l d.to_date, format: :web_input) if d                              ; end

  def html_input name, options={ }
    build_form_field name, options do |field_name, value|
      "<textarea name='#{field_name}' class='html-input'>#{preserve_newlines h(value)}</textarea>"
    end
  end

  def money_input name, options={ }
    build_form_field name, options do |field_name, value|
      v = value.is_a?(Numeric) ? number_to_currency(value) : value
      "<input class='numeric money' type='text' name='#{field_name}' value='#{v}'/>"
    end
  end

  def date_input name, options={ }
    build_form_field name, options do |field_name, value|
      v = value ? web_date(value) : value
      "<input class='date_input' type='text' name='#{field_name}' value='#{h v}' placeholder='#{i18n.t("ffb.date.placeholder")}'/>"
    end
  end

  def quantity_input name, options={ }
    build_form_field name, options do |field_name, value|
      v = value.is_a?(Numeric) ? show_integer(value) : value
      "<input class='numeric' type='text' name='#{field_name}' value='#{h v}'/>"
    end
  end

  def integer_input name, options={ }
    build_form_field name, options do |field_name, value|
      "<input class='numeric' type='text' name='#{field_name}' value='#{h value}'/>"
    end
  end

  def decimal_input name, options={ }
    build_form_field name, options do |field_name, value|
      v = value.is_a?(Numeric) ? show_decimal(value, (options.delete(:precision) || guess_precision(value))) : value
      "<input class='numeric' type='text' name='#{field_name}' value='#{h v}'#{placeholder options}/>"
    end
  end

  def text_input name, options={ }
    build_form_field name, options do |field_name, value|
      "<input type='text' name='#{field_name}' value='#{h value}'#{placeholder options}/>"
    end
  end
end
