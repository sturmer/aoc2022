defmodule Day02Test do
  use ExUnit.Case
  doctest Aoc2022.Day02
  import Aoc2022.Day02

  test "part 1" do
    assert solve_part_one("input/day02.sample.txt") == 15
    assert solve_part_one("input/day02.txt") == 10718
  end

  test "part 2" do
    # assert find_max_sum_cal(["1", "2", "3", "", "4", "", "1", "2", "4", "", "3"]) == 17
  end
end
