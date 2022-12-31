defmodule GraphNode do
  defstruct [size: nil, children: []]

  @doc """
    A graph is just a map label => node struct.
  """
  def size(node_label, graph) do
    node = Map.get(graph, node_label)

    node.size ||
      Enum.reduce(node.children, 0, fn c, acc ->
        acc + (size(c, graph) || 0)
      end)
  end

  @doc """
    iex> GraphNode.add_child(%GraphNode{size: 0, children: ["B", "C"]}, "D")
    %GraphNode{size: 0, children: ["B", "C", "D"]}
  """
  def add_child(node, child) do
    %{node | children: node.children ++ [child]}
  end

  @doc """
    iex> GraphNode.to_string(%GraphNode{size: nil, children: ["B", "C"]})
    "(size: nil) -> [B, C]"
  """
  def to_string(node) do
    children_string =
      Enum.reduce(node.children, "", fn s, acc ->
        case String.length(acc) do
          0 -> s
          _ -> "#{acc}, #{s}"
        end
      end)

    "(size: #{node.size || "nil"}) -> [#{children_string}]"
  end

  @doc """
    A more compact representation.

    iex> GraphNode.to_s(%GraphNode{size: nil, children: ["B","C"]})
    "(B,C)"
  """
  def to_s(node) do
    children_string =
      Enum.reduce(node.children, "", fn s, acc ->
        case String.length(acc) do
          0 -> s
          _ -> "#{acc},#{s}"
        end
      end)

    size_string = node.size

    details =
      if is_nil(size_string) do
        "(#{children_string})"
      else
        size_string
      end

    "#{details}"
  end

  def new() do
    %GraphNode{size: nil, children: []}
  end

  def new(size) do
    %GraphNode{size: String.to_integer(size), children: []}
  end
end
