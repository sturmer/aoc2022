defmodule Aoc2022.Day03 do
  @lowercase ?a..?z |> Enum.to_list()
  @uppercase ?A..?Z |> Enum.to_list()
  @item_codes @lowercase ++ @uppercase

  def solve_part_one(file) do
    case File.read(file) do
      {:ok, content} ->
        content
        |> String.split("\n", trim: true)
        |> add_priorities
    end
  end

  def add_priorities(rucksacks) do
    Enum.reduce(rucksacks, 0, fn rucksack, acc -> acc + add_priority(find_common(rucksack)) end)
  end


  @doc """
    iex> Aoc2022.Day03.find_common("vJrwpWtwJgWrhcsFMMfFFhFp")
    "p"
    iex> Aoc2022.Day03.find_common("jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL")
    "L"
    iex> Aoc2022.Day03.find_common("PmmdzqPrVvPwwTWBwg")
    "P"
    iex> Aoc2022.Day03.find_common("wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn")
    "v"
    iex> Aoc2022.Day03.find_common("ttgJtRGJQctTZtZT")
    "t"
    iex> Aoc2022.Day03.find_common("CrZsJsPPZsGzwwsLwLmpwMDw")
    "s"
  """
  def find_common(r) do
    len = String.length(r)

    elems = String.split(r, "", trim: true)
    compartment_one = Enum.take(elems, Integer.floor_div(len, 2)) |> MapSet.new
    compartment_two = Enum.take(elems, -Integer.floor_div(len, 2)) |> MapSet.new

    # Alternative (note - can add `|> IO.inspect` mid-pipeline to inspect result of the step):
    # compartment_one = String.slice(r, 0, Integer.floor_div(len, 2) - 1) |> IO.inspect |> String.split("", trim: true) |> MapSet.new
    # compartment_two = String.slice(r, Integer.floor_div(len, 2), len - 1) |> String.split("", trim: true) |> MapSet.new

    MapSet.intersection(compartment_one, compartment_two) |> MapSet.to_list() |> Enum.at(0)
  end

  @doc """
    iex> Aoc2022.Day03.add_priority("p")
    16
    iex> Aoc2022.Day03.add_priority("L")
    38
    iex> Aoc2022.Day03.add_priority("P")
    42
    iex> Aoc2022.Day03.add_priority("v")
    22
    iex> Aoc2022.Day03.add_priority("t")
    20
    iex> Aoc2022.Day03.add_priority("s")
    19
"""
  def add_priority(r) do
    ch = String.to_charlist(r) |> Enum.at(0)
    Enum.find_index(@item_codes, &(&1 == ch)) + 1
  end
end
