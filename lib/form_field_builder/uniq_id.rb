class FormFieldBuilder::UniqId
  def initialize ; @n = 0                   ; end
  def val        ; @n = (@n + 1) % 10000000 ; end
  def reset      ; @n = 0                   ; end
end
