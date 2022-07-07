require 'active_support/core_ext/array/wrap'

module FormFieldBuilder::SelectFieldBehaviour
  def select name, choices, options={ }
    build_form_field(name, options) { |field_name, value| raw_select field_name, value, choices, options }
  end

  def select_names name, names, options={ }
    select(name, names.map { |n| [n,n] }, options)
  end

  def select_as_tags name, choices, columns=3, options={ }
    build_form_field(name, options) { |field_name, value|
      hidden_input = hidden name, value: value
      buttons = Ui::TagSelectBuilder.new.build field_name, choices, columns
      "#{hidden_input}#{buttons}"
    }
  end

  def multi_check name, choices, opts={}
    build_form_field(name, opts.merge(array_field: true)) { |fname, val| build_checks fname, val, choices, opts }
  end

  def multi_check_i18n   name, key, opts={} ; multi_check name, select_options_from_i18n(key, opts), opts            ; end
  def please_select  name, choices, opts={} ; select name, prepend_please(choices), opts                             ; end
  def i18n_select        name, key, opts={} ; select name, select_options_from_i18n(key, opts), opts                 ; end
  def please_i18n_select name, key, opts={} ; select name, prepend_please(select_options_from_i18n(key, opts)), opts ; end
  def please_select_objects name, objs, meth, opts={} ; select name, prepend_please(objs.selectify meth), opts       ; end
  def select_objects        name, objs, meth, opts={} ; select name, objs.selectify(meth), opts                      ; end

  private

  def prepend_please choices ; ([[nil, i18n.t("select.please")]] + choices) ; end

  def raw_select field_name, value, choices, options
    value        = parameterise value
    cssclass     = options[:class] ? " class='#{options[:class]}'" : ""
    choices_html = choices.map { |o| select_option o, value }.join
    multiple     = " multiple='multiple'" if options[:multiple]
    "<select name='#{field_name}'#{cssclass}#{multiple}>#{choices_html}</select>"
  end

  def select_option option, value
    selected = ("#{value}".eql?("#{option[0]}")) ? " selected='selected'" : ""
    "<option value='#{h option[0]}'#{selected}>#{h option[1]}</option>".html_safe
  end

  def build_checks field_name, values, choices, options
    values       = Array.wrap(values).map { |v| parameterise v }.map &:to_s
    choices_html = choices.map { |o| check_option field_name, o, values }.join
    "<div class='check-all-scope #{field_name.gsub(/\W/, '-').gsub(/-+/, '-')} #{options[:class]}'>#{options[:check_all]}#{choices_html}</div>".html_safe
  end

  def check_option field_name, option, values
    uniq_id  = "#{field_name.gsub(/[^[:alnum:]]/, '')}-#{@uniq.val}"
    selected = values.include?(option[0].to_s) ? " checked='checked'" : ""
    check_html = "<input id='#{uniq_id}' type='checkbox' name='#{field_name}' value='#{h option[0]}'#{selected}/>"
    label_html = "<label for='#{uniq_id}'>#{option[1]}</label>"
    "<div class='radio_container'>#{check_html}#{label_html}</div>"
  end

  def slice_select_options opts, incs, exes
    opts = opts.slice(*incs) if incs.present?
    opts = opts.except(*exes) if exes.present?
    opts
  end

  def select_options_from_i18n key, opts={}
    slice_select_options(i18n.t(*key), opts[:includes], opts[:excludes]).to_a
  end
end
