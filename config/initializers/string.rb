class String
  # The inverse of Array#include?. Purely for code vanity.
  def in?(array)
    array.include?(self)
  end
end