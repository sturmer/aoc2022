defmodule Day04 do
  def solve_part_one(file) do
    case File.read(file) do
      {:ok, content} ->
        content
        |> String.split("\n", trim: true)
        |> count_full_inclusions()
    end
  end

  def count_full_inclusions(pairs) do
    pairs
    |> Enum.reduce(0, fn pair, acc -> acc + if is_full_inclusion?(pair), do: 1, else: 0 end)
  end

  @doc """
    iex> Day04.is_full_inclusion?("2-4,6-8")
    false
  """
  def is_full_inclusion?(pair) do
    [one, two] = String.split(pair, ",", trim: true)
    r1 = one |> normalize_range() |> MapSet.new()
    r2 = two |> normalize_range() |> MapSet.new()

    MapSet.subset?(r1, r2) || MapSet.subset?(r2, r1)
  end

  @doc """
    iex> Day04.normalize_range("4-9")
    4..9
  """
  def normalize_range(str) do
    params =
      str
      |> String.split("-")
      |> Enum.map(&String.to_integer/1)
    Kernel.apply(Range, :new, params)
  end
end
