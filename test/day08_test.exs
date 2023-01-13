defmodule Day08Test do
  use ExUnit.Case
  doctest Day08
  import Day08

  # test "read matrix from file" do
  #   # assert count_visible_trees("input/day08.sample.txt.csv") == 21
  # end

  test "can solve part 1 sample" do
    assert solve("input/day08.sample.txt", :one) == 21
  end

  test "part 1" do
    assert solve("input/day08.txt", :one) == 1825
  end

  test "can solve part 2 sample" do
    assert solve("input/day08.sample.txt", :two) == 8
  end

  test "part 2" do
    assert solve("input/day08.txt", :two) == 8
  end
end
