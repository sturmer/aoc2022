defmodule Day04Test do
  use ExUnit.Case
  doctest Day04
  import Day04

  test "part 1" do
    assert solve_part_one("input/day04.sample.txt") == 2
    assert solve_part_one("input/day04.txt") == 498
  end
end
