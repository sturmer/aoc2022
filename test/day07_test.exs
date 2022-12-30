defmodule Day07Test do
  use ExUnit.Case
  doctest Day07
  import Day07

  test "can solve part 1 sample" do
    assert solve("input/day07.sample.txt", :one) == 95_437
  end

  test "part 1" do
    # FIXME(gianluca): This is the wrong answer :(
    assert solve("input/day07.txt", :one) == 859_613
  end
end
