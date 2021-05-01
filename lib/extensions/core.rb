class String
  def to_boolean
    s = self.strip_downcase
    case s
    when "t", "y"
      true
    when 'f', 'n'
      false
    else
      ActiveRecord::Type::Boolean.new.cast(s)
    end
  end

  def shuffle
    self.chars.shuffle.join
  end

  def squish_downcase
    self.squish.downcase
  end

  def squish_upcase
    self.squish.upcase
  end

  def strip_downcase
    self.strip.downcase
  end

  def strip_upcase
    self.strip.upcase
  end
end

class NilClass
  def to_boolean
    false
  end
end

class TrueClass
  def to_boolean
    true
  end

  def to_i
    1
  end
end

class FalseClass
  def to_boolean
    false
  end

  def to_i
    0
  end
end

class Integer
  def to_boolean
    to_s.to_boolean
  end
end

class Hash
  def decamelize_keys
    self.deep_transform_keys{ |key| key.to_s.underscore }
  end

  def camelize_keys
    self.deep_transform_keys{ |key| key.to_s.camelize(:lower) }
  end
end

class Array
  def decamelize_objects
    self.map { |obj| obj.decamelize_keys }
  end

  def camelize_objects
    self.map { |obj| obj.camelize_keys }
  end
end
