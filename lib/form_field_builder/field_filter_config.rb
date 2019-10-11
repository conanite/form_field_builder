class FormFieldBuilder::FieldFilterConfig
  attr_accessor :config

  def initialize      ; @config = Hash.new { |h, k| h[k] = FormFieldBuilder::FilterChain.new } ; end
  def show? attr, obj ; config[attr.to_sym].show? obj                                          ; end
  def merge  more_cfg ;  more_cfg.each { |attr, filter| @config[attr] << filter }       ; self ; end
  def attr_to_s a, ff ; "#{a.to_s.ljust(20)}\n#{ff.map(&:to_s).join("\n") }"                   ; end
  def to_s            ; config.map { |attr, filters| attr_to_s attr, filters }.sort.join("\n") ; end
  def dup             ; self.class.new.tap { |d| config.each { |k,v| d.config[k] = v.dup } }   ; end
end
