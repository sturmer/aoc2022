defmodule Aoc2022.Day01 do
  def solve_part_one do
    case File.read("input/day01.sample.txt") do
      {:ok, content} -> content
      |> String.split("\n")
      |> find_max_cal
    end
  end

  def find_max_cal(lst) do
    Enum.chunk_by(lst, &(&1 == ""))
    |> Enum.reject(&(Enum.at(&1, 0) == "" && Kernel.length(&1) == 1))
    |> to_lists_of_ints([])
    |> Enum.map(fn x -> Enum.sum(x) end)
    |> Enum.max
  end

  def to_lists_of_ints([h | rest], res) do
    to_lists_of_ints(rest, [Enum.map(h, &String.to_integer/1) | res])
  end

  def to_lists_of_ints([], res) do
    res
  end

  def solve_part_two do
    case File.read("input/day01.txt") do
      {:ok, content} -> content
      |> String.split("\n")
      |> find_max_sum_cal
    end
  end

  def find_max_sum_cal(lst) do
    Enum.chunk_by(lst, &(&1 == ""))
    |> Enum.reject(&(Enum.at(&1, 0) == "" && Kernel.length(&1) == 1))
    |> to_lists_of_ints([])
    |> Enum.map(fn x -> Enum.sum(x) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum
  end
end
