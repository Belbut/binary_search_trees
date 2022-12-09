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

  #   def insert(value, present_node = root)
  #     return present_node.value = value if present_node.value.nil? # if tree is empty
  #     return if value == present_node.value # value already in tree do nothing

  #     if value >= present_node.value
  #       return present_node.child_right = Node.new(value) if present_node.child_right.nil?

  #       insert(value, present_node.child_right)
  #     else
  #       return present_node.child_right = Node.new(value) if present_node.child_left.nil?

  #       insert(value, present_node.child_left)
  #     end
  #   end


  def insert(value, node = root)
    return Node.new(value) if node.nil? || node.value.nil?
    
    if value < node.value
      node.child_left = insert(value, node.child_left)
    else
      node.child_right = insert(value, node.child_right)
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
tree.insert(67)
p tree
tree.pretty_print
