class FormFieldBuilder::Decorated < FormFieldBuilder::Base
  attr_accessor :filter, :tag
  attr_reader :plain

  def self.add_methods mod
    include mod
  end

  def initialize target=nil, options={ }
    super
    @plain    = FormFieldBuilder::Plain.new target, options
    @filter   = options[:filter] || FormFieldBuilder::NoFilter
    @tag      = options[:tag]    || "li"
    @no_label = options[:no_label]
  end

  def filtering attr, options={}
    return "" if options.key?(:if) && !options[:if]
    yield if self.filter.show? (options[:depends] || attr).to_sym, target
  end

  def override_field_label name_for_key, options
    # your personal tricky labelling business goes on here
  end

  def field_label name_for_key, options
    locally(options[:lbl])                         ||
      override_field_label(name_for_key, options)  ||
      options[:label]                              ||
      texts_for(options).label(target_class_name, name_for_key, options)
  end

  def build_label_node name_for_key, options
    return "" if @no_label || options[:no_label]
    required = options[:required] ? "<span class='required'>*</span>" : ""
    txt = wrap_tag? field_label(name_for_key, options), "span", :class => "label-txt"
    contents = [txt, required, options[:end_label]].reject(&:blank?).join ' '
    txt ? "<label class='input-label' for='#{options[:input][:id]}'>#{contents}</label>" : ""
  end

  def build_description name_for_key, options={}
    description   = locally(options[:desc]) if options[:desc]
    description ||= texts_for(options).description(target_class_name, name_for_key, options) if options[:description]
    description ? "<p class='description'>#{description}</p>" : ""
  end

  def build_post_description name_for_key, options={}
    description =  locally(options[:post_desc]) unless options[:post_desc].blank?
    description ? "<p class='description'>#{description}</p>" : ""
  end

  def form_field name_for_key, content, css_class, options={ }
    defaults        = { required: false, id: nil }
    options         = defaults.merge(options)
    error           = "<div class='error_container'></div>"
    label_node      = build_label_node       name_for_key, options
    desc_node       = build_description      name_for_key, options
    post_desc_node  = build_post_description name_for_key, options
    "<#{tag} class='input_row #{css_class}'#{as_attributes options[:tag_attributes]}>#{options[:before_label]}#{label_node}#{desc_node}#{content}#{error}#{post_desc_node}</#{tag}>".html_safe
  end

  def normalized_name name, options ; options[:preserve_id_suffix] ? name : name.to_s.gsub(/_ids?$/, '') ; end
  def label_text   name, options={} ; field_label normalized_name(name, options), options                ; end

  def build_form_field name, options={ }
    name_for_key = normalized_name name, options
    options[:input] ||= { }
    options[:input][:id] ||= "_i#{((Time.now.to_f * 100000) % 1000000).to_i.to_s 36}#{(rand * 10000).to_i.to_s 26}i_"
    self.filtering name_for_key, options do
      options[:placeholder] = texts_for(options).placeholder(target_class_name, name_for_key, options) if (options[:placeholder] == true)
      options[:name_for_key] = name_for_key
      form_field name_for_key, yield(field_name_for(name, options), value_for_field(name, options)), "#{css_class_prefix}-#{name} #{options[:css_class]}".strip, options
    end
  end
end
