class FormFieldBuilder::FilterChain < Array
  def show? obj ; all? { |f| f.show? obj } ; end
end
