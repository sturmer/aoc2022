defmodule Day01Test do
  use ExUnit.Case
  doctest Aoc2022.Day01
  import Aoc2022.Day01

  test "part 1" do
    assert find_max_cal(["1", "2", "3", "", "4"]) == 6
  end

  test "part 2" do
    assert find_max_sum_cal(["1", "2", "3", "", "4", "", "1", "2", "4", "", "3"]) == 17
  end
end
