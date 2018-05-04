module Enumerable
  def selectify attr
    if attr.is_a?(Hash)
      id_attr    = attr[:name]
      label_attr = attr[:label]
    else
      id_attr    = :id
      label_attr = attr
    end

    map { |item| [item.send(id_attr), item.send(label_attr)] }
  end
end

class TrueClass
  def as_bool;     self; end
end

class FalseClass
  def as_bool;     self; end
end

class String
  YES_RXP = /^(yes|true|oui|ja|si)$/ unless defined?(YES_RXP)
  NO__RXP = /^(no|false|non|nein)$/  unless defined?(NO__RXP)

  def yes_or_no
    case self.downcase.strip; when YES_RXP; true; when NO__RXP; false; else raise "unrecognised boolean value #{self}"; end
  end

  def as_bool
    case self.downcase.strip
    when YES_RXP; true
    when NO__RXP; false
    else nil
    end
  end
end

class NilClass
  def as_bool              ; self    ; end
end
