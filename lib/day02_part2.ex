defmodule Aoc2022.Day02.Part2 do
  def solve(file) do
    case File.read(file) do
      {:ok, content} ->
        content
        |> String.split("\n")
        |> Enum.reduce(0, fn x, acc -> eval_line(x) + acc end)
    end
  end

  @doc """
    X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win.

    iex> Aoc2022.Day02.Part2.eval_line("A X")
    3
    iex> Aoc2022.Day02.Part2.eval_line("A Y")
    4
    iex> Aoc2022.Day02.Part2.eval_line("A Z")
    8
    iex> Aoc2022.Day02.Part2.eval_line("B X")
    1
    iex> Aoc2022.Day02.Part2.eval_line("B Y")
    5
    iex> Aoc2022.Day02.Part2.eval_line("B Z")
    9
    iex> Aoc2022.Day02.Part2.eval_line("C X")
    2
    iex> Aoc2022.Day02.Part2.eval_line("C Y")
    6
    iex> Aoc2022.Day02.Part2.eval_line("C Z")
    7
"""
  def eval_line(""), do: 0
  def eval_line(l) do
    [opponent, desired_outcome] = String.split(l)
    parsed_opponent = parse_opponent(opponent)
    parsed_desired_outcome = parse_desired_outcome(desired_outcome)
    score_match(parsed_opponent, parsed_desired_outcome)
  end

  def score_match("Rock", 6), do: score_hand("Paper") + 6
  def score_match("Rock", 3), do: score_hand("Rock") + 3
  def score_match("Rock", 0), do: score_hand("Scissors") + 0
  def score_match("Paper", 6), do: score_hand("Scissors") + 6
  def score_match("Paper", 3), do: score_hand("Paper") + 3
  def score_match("Paper", 0), do: score_hand("Rock") + 0
  def score_match("Scissors", 6), do: score_hand("Rock") + 6
  def score_match("Scissors", 3), do: score_hand("Scissors") + 3
  def score_match("Scissors", 0), do: score_hand("Paper") + 0

  @doc """
    iex> Aoc2022.Day02.Part2.parse_opponent("A")
    "Rock"
    iex> Aoc2022.Day02.Part2.parse_opponent("B")
    "Paper"
  """
  def parse_opponent("A"), do: "Rock"
  def parse_opponent("B"), do: "Paper"
  def parse_opponent("C"), do: "Scissors"

  def parse_desired_outcome("X"), do: 0
  def parse_desired_outcome("Y"), do: 3
  def parse_desired_outcome("Z"), do: 6

  @doc """
    iex> Aoc2022.Day02.score_hand("Rock")
    1
  """
  def score_hand("Rock"), do: 1
  def score_hand("Paper"), do: 2
  def score_hand("Scissors"), do: 3
end
