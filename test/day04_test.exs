defmodule Day04Test do
  use ExUnit.Case
  doctest Day04
  import Day04

  test "part 1" do
    assert solve("input/day04.sample.txt", :one) == 2
    assert solve("input/day04.txt", :one) == 498
  end

  test "part 2" do
    assert solve("input/day04.sample.txt", :two) == 4
    assert solve("input/day04.txt", :two) == 859
  end
end
