module FormFieldBuilder::FieldFilter
  def setup_filter_config
    @filter_config ||= superclass.filter_config.dup if superclass.respond_to?(:filter_config)
    @filter_config ||= FormFieldBuilder::FieldFilterConfig.new
  end

  def filter_config config=:not_set
    setup_filter_config

    case config
    when :not_set; @filter_config
    else @filter_config.merge config
    end
  end

  def replace_filter_config config
    setup_filter_config
    @filter_config.replace config
  end

  class FilterByNever < Struct.new(:key)
    def to_s          ; "never | #{key.inspect}" ; end
    def show?(*)      ; false                    ; end
  end

  class FilterByAlways < Struct.new(:key)
    def to_s          ; "always | #{key.inspect}" ; end
    def show?(*)      ; true                      ; end
  end

  class FilterByProc < Struct.new(:name, :proc)
    def to_s          ; "proc | #{name.inspect} #{proc.inspect}" ; end
    def show?(*args)  ; proc.call(name, *args)   ; end
  end

  # useful for subclasses with differing configs to share a single #form view
  # example (avoid showing #blackmail and #extortion fields in an innocent subclass)
  #
  # class InnocentFoo < AbstractFoo
  #   filter_config never_show :blackmail, :extortion
  # end
  #
  def never_show *names
    names.each_with_object({}) { |name, hsh| hsh[name.to_sym] = FilterByNever.new(name) }
  end

  def always_show *names
    names.each_with_object({}) { |name, hsh| hsh[name.to_sym] = FilterByAlways.new(name) }
  end

  def proc_filter opts
    opts.each_with_object({}) { |(field, proc), hsh| hsh[field.to_sym] = FilterByProc.new(field, proc) }
  end
end
