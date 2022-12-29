defmodule GraphNodeTest do
  use ExUnit.Case
  doctest GraphNode
  import GraphNode

  @graph %{
    a: %GraphNode{label: :a, size: nil, children: [:b]},
    b: %GraphNode{label: :b, size: nil, children: [:c, :d]},
    c: %GraphNode{label: :c, size: 100, children: []},
    d: %GraphNode{label: :d, size: nil, children: [:e]},
    e: %GraphNode{label: :e, size: 200, children: []}
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
      @graph | a: %GraphNode{label: "a", size: nil, children: [:b, :d]}
    }
    assert GraphNode.size(:a, graph) == 500
  end

  @doc """
    %{
      "/" => %{
        "a" => %{"e" => %{"i" => 584}, "f" => 29116, "g" => 2557, "h.lst" => 62596},
        "b.txt" => 14848514,
        "c.dat" => 8504156,
        "d" => %{
          "d.ext" => 5626152,
          "d.log" => 8033020,
          "j" => 4060174,
          "k" => 7214296
        }
      }
    }
  """
  test "example from part 1 computes sizes correctly" do
    graph =  %{
      "/" => %GraphNode{label: "/", size: nil, children: ["a", "b.txt", "c.dat", "d"]},
      "a" => %GraphNode{label: "a", size: nil, children: ["e", "f", "g", "h.lst"]},
      "e" => %GraphNode{label: "e", size: nil, children: ["i"]},
      "i" => %GraphNode{label: "i", size: 584, children: []},
      "f" => %GraphNode{label: "f", size: 29116, children: []},
      "g" => %GraphNode{label: "g", size: 2557, children: []},
      "h.lst" => %GraphNode{label: "h.lst", size: 62596, children: []},
      "b.txt" => %GraphNode{label: "b.txt", size: 14848514, children: []},
      "c.dat" => %GraphNode{label: "c.dat", size: 8504156, children: []},
      "d" => %GraphNode{label: "d", size: nil, children: ["d.ext", "d.log", "j", "k"]},
      "d.ext" => %GraphNode{label: "d.ext", size: 5626152, children: []},
      "d.log" => %GraphNode{label: "d.log", size: 8033020, children: []},
      "j" => %GraphNode{label: "j", size: 4060174, children: []},
      "k" => %GraphNode{label: "k", size: 7214296, children: []}
    }

    assert GraphNode.size("e", graph) == 584
    assert GraphNode.size("a", graph) == 94853
    assert GraphNode.size("d", graph) == 24933642
    assert GraphNode.size("/", graph) == 48381165
  end
end
