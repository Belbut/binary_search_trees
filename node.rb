# Node class for Binary Search Trees
# Includes Comparable Module, meaning we can directly compare between two Nodes
class Node
  include Comparable

  attr_accessor :value, :child_left, :child_right

  def initialize(value, child_left = nil, child_right = nil)
    @value = value
    @child_left = child_left
    @child_right = child_right
  end

  def <=>(other)
    @value <=> other.value
  end
end
