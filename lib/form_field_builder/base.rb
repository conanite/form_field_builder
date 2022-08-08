require 'i18n'
require 'form_field_builder/i18n_text_provider'
require 'active_support/inflector'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/string/output_safety'

#
# #texts is an object providing #label, #placeholder, and #description methods to decorate form fields
# #i18n provides translations for simple options, eg "yes" and "no"
#
class FormFieldBuilder::Base
  include ERB::Util
  include FormFieldBuilder::TextInputBehaviour
  include FormFieldBuilder::RadioFieldBehaviour
  include FormFieldBuilder::SelectFieldBehaviour

  class NilAccessor
    def self.get _ ; end
  end

  class PoroAccessor < Struct.new(:target)
    def get name ; target.send(name) ; end
  end

  class HashAccessor < Struct.new(:target)
    def get name ; target[name] ; end
  end

  @@text_providers = { }

  def self.register_text_provider name, provider
    @@text_providers[name] = provider
  end

  attr_reader :target
  attr_accessor :input_name_prefix, :css_class_prefix, :target_class_name, :i18n, :texts, :text_providers

  def target= tgt
    @target  = tgt
    @target_accessor =  if tgt.is_a?(Hash)
                          HashAccessor.new(target)
                        elsif target
                          PoroAccessor.new(target)
                        else
                          NilAccessor
                        end
  end

  def initialize target=nil, options={ }
    @options  = options
    self.target = target

    @uniq              = options[:uniq] || FormFieldBuilder::UniqId.new
    @target_class_name = options[:class_name] || underscore_more(target.class.name)
    @input_name_prefix = options[:prefix] || options[:input_name_prefix] || @target_class_name
    @css_class_prefix  = @input_name_prefix.to_s.gsub(/\[/, "-").gsub(/\]/, '')
    @i18n              = options[:i18n] || I18n
    @texts             = options[:texts] || FormFieldBuilder::I18nTextProvider.new(i18n: i18n)
  end

  def texts_for opts ; opts[:texts] ? @@text_providers[opts[:texts].to_sym] : texts  ; end

  def sub name, prefix, options={}
    v       = (name ? value_for_field(name, options) : nil) || options[:default_value]
    fn      = field_name_for(prefix, options)
    newopts = @options.merge(prefix: fn).merge(options[:sub] || {})
    self.class.new v, newopts
  end

  def locally obj
    obj.is_a?(Hash) ? (obj[i18n.locale.to_s] || obj[i18n.locale.to_sym]) : obj
  end

  def build_field_name name, suffix
    if input_name_prefix.blank?
      "#{name}#{suffix}"
    else
      "#{input_name_prefix}[#{name}]#{suffix}"
    end
  end

  def has_many_association? name
    return target &&
      target.class.respond_to?(:reflect_on_association) &&
      (assoc = target.class.reflect_on_association(name.to_sym)) &&
      (assoc.macro == :has_many)
  end

  def belongs_to_association? name
    return target &&
      target.class.respond_to?(:reflect_on_association) &&
      (assoc = target.class.reflect_on_association(name.to_sym)) &&
      (assoc.macro == :belongs_to)
  end

  def behaves_like_belongs_to? name
    return target &&
      !target.class.respond_to?(:reflect_on_association) &&
      target.respond_to?(name) &&
      target.respond_to?("#{name}=") &&
      target.respond_to?("#{name}_id") &&
      target.respond_to?("#{name}_id=")
  end

  def append__ids? name
    sing = name.to_s.singularize
    return target &&
      target.respond_to?(name) &&
      target.respond_to?("#{name}=") &&
      target.respond_to?("#{sing}_ids") &&
      target.respond_to?("#{sing}_ids=")
  end

  def field_name_for name, options
    if options[:field_name]
      options[:field_name]
    elsif has_many_association? name
      build_field_name("#{name}_attributes", "[]")
    elsif append__id? name
      build_field_name("#{name}_id", '')
    elsif append__ids? name
      build_field_name("#{name.to_s.singularize}_ids", '[]')
    else
      build_field_name(name, options[:array_field] ? "[]" : '')
    end
  end

  def underscore_more                str ; str.gsub(/([[:alpha:]])([[:upper:]])/, '\1_\2').downcase.gsub(/\/|::/, "_") ; end
  def append__id?                   name ; belongs_to_association?(name) || behaves_like_belongs_to?(name) ; end
  def parameterise                 value ; value.respond_to?(:to_param) ? value.to_param : value           ; end
  def try_target          alt_name, name ; @target_accessor.get((alt_name || name).to_sym)                 ; end
  def value_for_field      name, options ; options.key?(:value) ? options[:value] : try_target(options[:from], name) ; end
  def build_form_field name, options={ } ; raise "not implemented"                                         ; end
  def wrap_tag       txt, tag, tag_attrs ; "<#{tag}#{as_attributes tag_attrs}>#{txt}</#{tag}>"             ; end
  def wrap_tag?      txt, tag, tag_attrs ; txt.blank? ? "" : wrap_tag(txt, tag, tag_attrs)                 ; end
  def custom       name, options={ }, &b ; build_form_field name, options, &b                              ; end

  def as_attributes options={}
    result=""
    (options || {}).each_pair { |k,v| result = "#{result} #{k}='#{v.to_s.gsub(/'/, '&#39;')}'" unless v.blank? }
    result
  end

  def hidden name, options={ }
    "<input type='hidden' name='#{field_name_for name, options}' value='#{h parameterise value_for_field name, options}#{disabled options}'/>".html_safe
  end


  def text_area name, options={ }
    build_form_field name, options do |field_name, value|
      "<textarea name='#{field_name}' rows='#{options[:rows] || 6}'#{placeholder options}#{disabled options}>#{preserve_newlines h(value)}</textarea>"
    end
  end

  def label_only name, options={ } ; build_form_field(name, options) { |*| "" } ; end

  def password name, options={ }
    build_form_field name, options do |field_name, value|
      "<input type='password' name='#{field_name}'#{as_attributes options[:input_attributes]}#{disabled options}/>"
    end
  end

  def file name, options={ }
    build_form_field name, options do |field_name, value|
      "<input type='file' name='#{field_name}'#{as_attributes options[:input]}#{disabled options}/>"
    end
  end

  def check name, check_value, options={ }
    build_form_field name, options do |field_name, value|
      checked = (check_value == value) ? " checked='checked'" : ''
      "<input type='checkbox' name='#{field_name}' value='#{check_value}'#{checked}#{disabled options}/>"
    end
  end

  def input_class given, options
    "#{given} #{options[:input_class]}".strip
  end

  protected

  def guess_precision number
    return 1 if number.nil?
    return 0 if number == number.to_i
    return 1 if (number * 10.0) == (number * 10).to_i
    return 2 if (number * 100.0) == (number * 100).to_i
    return 3 if (number * 1000.0) == (number * 1000).to_i
    2
  end

  def disabled           options ; options[:disabled] ? " disabled='disabled'" : ""                       ; end
  def preserve_newlines      txt ; txt.gsub(/\n/, '&#x000A;').gsub(/\r/, '')                              ; end
  def placeholder        options ; options[:placeholder] ? " placeholder='#{options[:placeholder]}'" : "" ; end
  def selectify collection, attr ; collection.selectify(attr)                                             ; end
end
