defmodule Day03Test do
  use ExUnit.Case
  doctest Aoc2022.Day03
  doctest Aoc2022.Day03.Part2
  import Aoc2022.Day03
  import Aoc2022.Day03.Part2

  test "part 1" do
    assert solve_part_one("input/day03.sample.txt") == 157
    assert solve_part_one("input/day03.txt") == 7980
  end

  test "part 2" do
    assert solve_part_two("input/day03.sample.txt") == 70
    assert solve_part_two("input/day03.txt") == 7980
  end
end
