defmodule Day07Test do
  use ExUnit.Case
  doctest Day07
  import Day07

  test "can solve part 1 sample" do
    # assert solve("input/day07.sample.txt", :one) == 95_437
  end

  test "part 1" do
    # assert solve("input/day07.txt", :one) == 1_084_134
  end

  test "can solve part 2 sample" do
    # assert solve("input/day07.sample.txt", :two) == 24_933_642
  end

  test "part 2" do
    # assert solve("input/day07.txt", :two) == 6_183_184
  end
end
