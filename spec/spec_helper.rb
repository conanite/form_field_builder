require 'aduki'
require 'form_field_builder'

module FormFieldBuilderHelpers
  def strip_each_line str
    str.gsub(/^\ +/, "").gsub(/\ +$/, "").gsub(/ *\n\ */, "\n")
  end

  class FakeTexts
    def self.label target_class_name, attr_name, options
      "the label of the #{attr_name} of the #{target_class_name}"
    end

    def self.placeholder target_class_name, attr_name, options
      "the placeholder of the #{attr_name} of the #{target_class_name}"
    end

    def self.description target_class_name, attr_name, options
      "the description of the #{attr_name} of the #{target_class_name}"
    end
  end

  FormFieldBuilder::Base.register_text_provider :fake, FakeTexts

  def glossary_texts
    FormFieldBuilder::I18nTextProvider.new(i18n: I18n, prefix: "glossary")
  end

  def label_builder target, options={}
    FormFieldBuilder::LabelOnly.new target, { texts: glossary_texts }.merge(options)
  end

  def form_field_builder target, options={}
    FormFieldBuilder::Decorated.new target, { texts: glossary_texts }.merge(options)
  end

  def expectable cssclass, label, content, desc=nil, tag="li", tag_attributes="", opts={}, post=nil
    "<#{tag} class='input_row #{cssclass}'#{tag_attributes}>
<label class='input-label' for='#{opts[:input_id] || "iNpUtId"}'>
<span class='label-txt'>#{label}</span></label>
#{[desc,content].compact.join("\n")}
<div class='error_container'></div>#{post.present? ? "\n#{post}" : ""}</#{tag}>"
  end

  def expect_label cssclass, label, tag="li"
    "<#{tag} class='#{cssclass}'>
<label class='input-label' for='iNpUtId'>
<span class='label-txt'>#{label}</span></label></#{tag}>"
  end

  def fix_field txt
    strip_each_line txt.to_s.gsub(/<([^\/])/, "\n<\\1").gsub(/\n\s*\n/, "\n").gsub(/_i[^_]+i_/, 'iNpUtId').strip
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus

  config.example_status_persistence_file_path = "spec/examples.txt"

  config.disable_monkey_patching!

  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = "doc"
  end

  # config.profile_examples = 10

  config.order = :random

  config.include FormFieldBuilderHelpers

  Kernel.srand config.seed

  I18n.load_path += Dir[File.join(File.expand_path("."), 'spec/locales', '*.yml').to_s]
  I18n.load_path += Dir[File.join(File.dirname(__FILE__), 'locales', '*.yml').to_s]
  I18n.backend.load_translations
  I18n.config.available_locales = %i{ en fr }
end

module AdukiBoolean ; def self.aduki_find str ; str.as_bool ; end ; end

class AttrDef < Aduki::Initializable
  attr_accessor :macro
end

class Model < Aduki::Initializable
  extend FormFieldBuilder::FieldFilter
end

class Group < Model
  attr_accessor :name, :purpose
  attr_many_finder :find, :id, :group_people, class_name: "GroupPerson"
  def self.reflect_on_association name
    return AttrDef.new(macro: :has_many) if name == :group_people
  end
end

class Entity < Model
  attr_accessor :phone

  @@showphone = false

  def self.gdpr field, obj
    @@showphone
  end

  def self.gdpr= b
    @@showphone = b
  end

  filter_config proc_filter phone: method(:gdpr)
end

class Person < Entity
  attr_accessor :id, :name, :height, :fingers, :import_id, :city, :sex, :photo, :type, :bio, :secret, :phone
  aduki happy: AdukiBoolean, dob: Date

  @@showsex = true

  def self.dating?
    @@showsex
  end

  filter_config proc_filter sex: method(:dating?)

  def to_param ; id ; end
end

class GroupPerson < Model
  attr_accessor :id
  attr_finder :find, :id, :person
  attr_finder :find, :id, :group
end
