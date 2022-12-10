defmodule Aoc2022.Day03.Part2 do
  @lowercase ?a..?z |> Enum.to_list()
  @uppercase ?A..?Z |> Enum.to_list()
  @item_codes @lowercase ++ @uppercase

  def solve_part_two(file) do
    case File.read(file) do
      {:ok, content} ->
        content
        |> String.split("\n", trim: true)
        |> add_priorities
    end
  end

  def add_priorities(rucksacks) do
    rucksacks
    |> Enum.chunk_every(3)
    |> Enum.reduce(0, fn group, acc ->
      acc + add_priority(Kernel.apply(__MODULE__, :find_common, group))
    end)
  end

  @doc """
    iex> Aoc2022.Day03.Part2.find_common("vJrwpWtwJgWrhcsFMMfFFhFp",
    ...>  "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
    ...>  "PmmdzqPrVvPwwTWBwg")
    "r"

    iex> Aoc2022.Day03.Part2.find_common("wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
    ...>  "ttgJtRGJQctTZtZT",
    ...>  "CrZsJsPPZsGzwwsLwLmpwMDw")
    "Z"
  """
  def find_common(r1, r2, r3) do
    r1
    |> String.split("", trim: true)
    |> MapSet.new()
    |> MapSet.intersection(find_common(r2, r3))
    |> MapSet.to_list()
    |> Enum.at(0)
  end

  def find_common(r1, r2) do
    two =
      r2
      |> String.split("", trim: true)
      |> MapSet.new()

    r1
    |> String.split("", trim: true)
    |> MapSet.new()
    |> MapSet.intersection(two)
  end

  @doc """
      iex> Aoc2022.Day03.Part2.add_priority("p")
      16
      iex> Aoc2022.Day03.Part2.add_priority("L")
      38
      iex> Aoc2022.Day03.Part2.add_priority("P")
      42
      iex> Aoc2022.Day03.Part2.add_priority("v")
      22
      iex> Aoc2022.Day03.Part2.add_priority("t")
      20
      iex> Aoc2022.Day03.Part2.add_priority("s")
      19
  """
  def add_priority(r) do
    ch = String.to_charlist(r) |> Enum.at(0)
    Enum.find_index(@item_codes, &(&1 == ch)) + 1
  end
end
