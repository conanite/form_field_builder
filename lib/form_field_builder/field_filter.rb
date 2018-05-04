module FormFieldBuilder::FieldFilter
  def filter_config config=:not_set
    @filter_config ||= FormFieldBuilder::FieldFilterConfig.new
    case config
    when :not_set; @filter_config
    else @filter_config.merge config
    end
  end
end
