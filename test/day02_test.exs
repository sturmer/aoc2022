defmodule Day02Test do
  use ExUnit.Case
  doctest Aoc2022.Day02
  doctest Aoc2022.Day02.Part2
  import Aoc2022.Day02
  import Aoc2022.Day02.Part2

  test "part 1" do
    assert solve_part_one("input/day02.sample.txt") == 15
    assert solve_part_one("input/day02.txt") == 10718
  end

  test "part 2" do
    assert solve("input/day02.sample.txt") == 12
    assert solve("input/day02.txt") == 14652
  end
end
