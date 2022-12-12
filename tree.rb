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
    else
      delete_with_child(value, node)
    end
    node
  end

  def find(value, node = root)
    return if node.nil?
    return node if node.value == value

    if value > node.value
      find(value, node.child_right)
    else
      find(value, node.child_left)
    end
  end

  #   # level order using iteration
  #   def level_order
  #     return if root.nil?

  #     queue = [root]
  #     result = []
  #     while queue.size.positive?
  #       node = queue.shift
  #       result.append(yield(node.value)) unless node.value.nil?
  #       queue.append(node.child_left) unless node.child_left.nil?
  #       queue.append(node.child_right) unless node.child_right.nil?
  #     end
  #     result
  #   end

  # level_order using recursion
  def level_order(result = [], queue = [root], &block)
    return if queue.size.zero?

    node = queue.shift
    result.append(yield(node.value)) unless node.value.nil?
    queue.append(node.child_left) unless node.child_left.nil?
    queue.append(node.child_right) unless node.child_right.nil?

    level_order(result, queue, &block)
    result
  end

  def preorder(result = [], node = root, &block)
    return if node.nil?

    result.append((yield(node.value))) unless node.value.nil?
    preorder(result, node.child_left, &block)
    preorder(result, node.child_right, &block)
    result
  end

  def inorder(result = [], node = root, &block)
    return if node.nil?

    inorder(result, node.child_left, &block)
    result.append((yield(node.value))) unless node.value.nil?
    inorder(result, node.child_right, &block)
    result
  end

  def postorder(result = [], node = root, &block)
    return if node.nil?

    postorder(result, node.child_left, &block)
    postorder(result, node.child_right, &block)
    result.append((yield(node.value))) unless node.value.nil?
    result
  end

  def height(node)
    # base conditon, needed to break out of recursion
    # It will break out from the base condition on every leaf, because it will find -1 / -1
    return 0 if node.nil?

    # Height from each side of the tree
    # it will traverse all nodes from the tree once
    # so it will make sure the furdest leaf is couth
    left_height = height(node.child_left)
    right_height = height(node.child_right)

    # On every leaf it will find -1/-1 returning 0
    # and that way the counter will start from the ground up finding (-1/0) ( -1/1)...
    [left_height, right_height].max + 1
  end

  #   def depth(node)
  #     height(root) - height(node)
  #   end

  def depth(goal_node, node = root)
    return -1 if node.nil? || goal_node.nil?
    return 1 if node == goal_node

    left = depth(goal_node, node.child_left)
    right = depth(goal_node, node.child_right)

    [left, right].max + 1
  end

  def balanced?
    node_balanced?
  end

  private

  def node_balanced?(node = root)
    return true if node.nil?
    return false if (height(node.child_left) - height(node.child_right)).abs > 1

    node_balanced?(node.child_left) && node_balanced?(node.child_right)
  end

  def delete_with_child(_value, node)
    return if node.child_left.nil? && node.child_right.nil?
    return node.child_right if node.child_left.nil?
    return node.child_left if node.child_right.nil?

    smalest_next_value = node.child_right
    smalest_next_value = smalest_next_value.child_left until smalest_next_value.child_left.nil?
    delete(smalest_next_value.value)
    node.value = smalest_next_value.value
    node
  end

  def populate_tree(sorted_array)
    size = sorted_array.size
    return Node.new(sorted_array[size - 1]) if size <= 1 # create leaf node

    mid = size / 2

    Node.new(sorted_array[mid], populate_tree(sorted_array[0...mid]), populate_tree(sorted_array[mid + 1..]))
  end
end

tree = Tree.new(%w[A B C D E F G ac dsa])
tree.pretty_print
p tree.balanced?
p " --------------- "
# unbalanced_tree
unbalanced_tree = tree.clone
unbalanced_tree.root.child_right = nil

unbalanced_tree.pretty_print
tree.pretty_print

p tree.balanced?
p unbalanced_tree.balanced?


