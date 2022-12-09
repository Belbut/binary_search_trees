class Tree
  require_relative './node'
  attr_accessor :root

  def initialize(tree_array)
    @root = build_tree(tree_array)
  end

  def build_tree(tree_array)
    sorted_array = tree_array.uniq.sort
    populate_tree(sorted_array)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    #   method that a TOP student wrote and shared on Discord
    pretty_print(node.child_right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.child_right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.child_left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.child_left
  end

  def insert(value, node = root)
    return Node.new(value) if node.nil? || node.value.nil?
    return node if value == node.value

    if value < node.value
      node.child_left = insert(value, node.child_left)
    else
      node.child_right = insert(value, node.child_right)
    end
    node
  end

  def delete(value, node = root)
    return node if node.nil?

    if value < node.value
      node.child_left = delete(value, node.child_left)
    elsif value > node.value
      node.child_right = delete(value, node.child_right)
    elsif node.child_left.nil? && node.child_right.nil?
      # we found the value
      return nil
    elsif node.child_left.nil?
      return node.child_right
    elsif node.child_right.nil?
      return node.child_left
    else
      smalest_next_value = node.child_right
      smalest_next_value = smalest_next_value.child_left until smalest_next_value.child_left.nil?
      delete(smalest_next_value.value)
      node.value = smalest_next_value.value

      return node
    end
    node
  end

  private

  def populate_tree(sorted_array)
    size = sorted_array.size
    return Node.new(sorted_array[size - 1]) if size <= 1 # create leaf node

    mid = size / 2

    Node.new(sorted_array[mid], populate_tree(sorted_array[0...mid]), populate_tree(sorted_array[mid + 1..]))
  end
end

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
tree.pretty_print
tree.delete(8)
tree.pretty_print
