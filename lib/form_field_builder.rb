require "active_support"
require "form_field_builder/version"
require "form_field_builder/uniq_id"
require "form_field_builder/core_ext"
require "form_field_builder/text_input_behaviour"
require "form_field_builder/radio_field_behaviour"
require "form_field_builder/select_field_behaviour"
require "form_field_builder/base"
require "form_field_builder/plain"
require "form_field_builder/decorated"
require "form_field_builder/label_only"
require "form_field_builder/filter_chain"
require "form_field_builder/field_filter_config"
require "form_field_builder/field_filter"

module FormFieldBuilder
  module NoFilter                    ; def self.show?(*)  ; true           ; end ; end
  class FilterByList < Set           ; def show?(attr, *) ; include?(attr) ; end ; end
  def self.simple_field_filter names ; FilterByList.new names.map(&:to_sym)      ; end

  def self.install_extension base_klass # normally ActiveRecord::Base
    base_klass.send :extend, FormFieldBuilder::FieldFilter
  end
end
