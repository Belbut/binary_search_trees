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

  private 

  def populate_tree(sorted_array)
    size = sorted_array.size
    return Node.new(sorted_array[size - 1]) if size <= 1              # create leaf node

    mid = size / 2

    Node.new(sorted_array[mid], populate_tree(sorted_array[0...mid]), populate_tree(sorted_array[mid + 1..])) 
  end
end

tree = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])

p tree
tree.pretty_print
