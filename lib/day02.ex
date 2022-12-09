defmodule Aoc2022.Day02 do
  def solve_part_one(file) do
    case File.read(file) do
      {:ok, content} ->
        content
        |> String.split("\n")
        |> Enum.reduce(0, fn x, acc -> Aoc2022.Day02.eval_line(x) + acc end)
    end
  end


  @doc """
    iex> Aoc2022.Day02.eval_line("A X")
    4
    iex> Aoc2022.Day02.eval_line("B Z")
    9
  """
  def eval_line(""), do: 0
  def eval_line(l) do
    [other, me] = String.split(l)
    parsed_me = parse_symbol(me)
    parsed_other = parse_symbol(other)
    score_hand(parsed_me) + match(parsed_me, parsed_other)
  end

  @doc """
    iex> Aoc2022.Day02.parse_symbol("A")
    "Rock"
    iex> Aoc2022.Day02.parse_symbol("X")
    "Rock"
  """
  def parse_symbol(s) do
    cond do
      s == "A" || s == "X" -> "Rock"
      s == "B" || s == "Y" -> "Paper"
      s == "C" || s == "Z" -> "Scissors"
    end
  end

  @doc """
    iex> Aoc2022.Day02.score_hand("Rock")
    1
  """
  def score_hand("Rock"), do: 1
  def score_hand("Paper"), do: 2
  def score_hand("Scissors"), do: 3
  def score_hand(_), do: :error

  @doc """
    0 if you lost, 3 if the round was a draw, and 6 if you won.

    iex> Aoc2022.Day02.match("Rock", "Scissors")
    6
    iex> Aoc2022.Day02.match("Rock", "Paper")
    0
    iex> Aoc2022.Day02.match("Rock", "Rock")
    3
    iex> Aoc2022.Day02.match("Paper", "Scissors")
    0
    iex> Aoc2022.Day02.match("Paper", "Paper")
    3
    iex> Aoc2022.Day02.match("Paper", "Rock")
    6
    iex> Aoc2022.Day02.match("Scissors", "Scissors")
    3
    iex> Aoc2022.Day02.match("Scissors", "Paper")
    6
    iex> Aoc2022.Day02.match("Scissors", "Rock")
    0
  """
  def match(me, me), do: 3
  def match("Rock", other) do
    if other == "Paper" do
      0
    else
      6
    end
  end

  def match("Paper", other) do
    if other == "Rock" do
      6
    else
      0
    end
  end

  def match("Scissors", other) do
    if other == "Paper" do
      6
    else
      0
    end
  end
end
