defmodule GraphNodeTest do
  use ExUnit.Case
  doctest GraphNode

  @graph %{
    a: %GraphNode{size: nil, children: [:b]},
    b: %GraphNode{size: nil, children: [:c, :d]},
    c: %GraphNode{size: 100, children: []},
    d: %GraphNode{size: nil, children: [:e]},
    e: %GraphNode{size: 200, children: []}
  }

  test "can measure size" do
    assert GraphNode.size(:a, @graph) == 300
    assert GraphNode.size(:b, @graph) == 300
    assert GraphNode.size(:c, @graph) == 100
    assert GraphNode.size(:d, @graph) == 200
    assert GraphNode.size(:e, @graph) == 200
  end

  @doc """
    a--->b -> c(100)
    |    |
    |    v
    +--->d -> e(200)
  """
  test "it will count twice a file if it appears with two parent directories" do
    graph = %{
      @graph
      | a: %GraphNode{size: nil, children: [:b, :d]}
    }

    assert GraphNode.size(:a, graph) == 500
  end

  @doc """
    This works once the sample file day07.sample.txt is correctly parsed to the graph.
  """
  test "example from part 1 computes sizes correctly" do
    graph = %{
      "/" => %GraphNode{size: nil, children: ["a", "b.txt", "c.dat", "d"]},
      "a" => %GraphNode{size: nil, children: ["e", "f", "g", "h.lst"]},
      "e" => %GraphNode{size: nil, children: ["i"]},
      "i" => %GraphNode{size: 584, children: []},
      "f" => %GraphNode{size: 29116, children: []},
      "g" => %GraphNode{size: 2557, children: []},
      "h.lst" => %GraphNode{size: 62596, children: []},
      "b.txt" => %GraphNode{size: 14_848_514, children: []},
      "c.dat" => %GraphNode{size: 8_504_156, children: []},
      "d" => %GraphNode{size: nil, children: ["d.ext", "d.log", "j", "k"]},
      "d.ext" => %GraphNode{size: 5_626_152, children: []},
      "d.log" => %GraphNode{size: 8_033_020, children: []},
      "j" => %GraphNode{size: 4_060_174, children: []},
      "k" => %GraphNode{size: 7_214_296, children: []}
    }

    assert GraphNode.size("i", graph) == 584
    assert GraphNode.size("e", graph) == 584
    assert GraphNode.size("a", graph) == 94853
    assert GraphNode.size("d", graph) == 24_933_642
    assert GraphNode.size("/", graph) == 48_381_165
  end
end
