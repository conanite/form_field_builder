class FormFieldBuilder::I18nTextProvider
  attr_accessor :i18n, :prefix

  def initialize options
    @i18n   = options[:i18n]   || I18n
    @prefix = options[:prefix] || "activerecord.attributes"
  end

  delegate :locale, to: :i18n

  def gloss_key target_type, attr, feature ; "#{prefix}.#{target_type}.#{attr}.#{feature}"    ; end
  def description_key                 opts ; opts[:description] == true ? :description : opts[:description] ; end
  def label_key                       opts ; opts[:label_subkey] || :label                                  ; end

  def text target_class_name, attr_name, feature
    i18n.t(gloss_key(target_class_name, attr_name, feature), raise: true)
  end

  def label target_class_name, attr_name, options
    text(target_class_name, attr_name, label_key(options))
  end

  def placeholder target_class_name, attr_name, options
    text(target_class_name, attr_name, :placeholder)
  end

  def description target_class_name, attr_name, options
    text(target_class_name, attr_name, (description_key options))
  end
end
