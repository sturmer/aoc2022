defmodule Day04 do
  def solve(file, part) do
    test_fun = case part do
      :one -> &is_full_inclusion?/1
      :two -> &is_overlap?/1
    end

    case File.read(file) do
      {:ok, content} ->
        content
        |> String.split("\n", trim: true)
        |> count_overlaps(test_fun)
    end
  end

  def count_overlaps(pairs, test_fun) do
    pairs
    |> Enum.reduce(0, fn pair, acc -> acc + if test_fun.(pair), do: 1, else: 0 end)
  end

  @doc """
    iex> Day04.is_full_inclusion?("2-4,6-8")
    false
  """
  def is_full_inclusion?(pair) do
    [r1, r2] = pair_to_mapsets(pair)
    MapSet.subset?(r1, r2) || MapSet.subset?(r2, r1)
  end

  def is_overlap?(pair) do
    [r1, r2] = pair_to_mapsets(pair)
    (MapSet.intersection(r1, r2) |> MapSet.size()) > 0
  end

  def pair_to_mapsets(p) do
    [one, two] = String.split(p, ",", trim: true)
    r1 = one |> normalize_range() |> MapSet.new()
    r2 = two |> normalize_range() |> MapSet.new()

    [r1, r2]
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
