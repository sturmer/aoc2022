defmodule Day08 do
  def solve(file, _part) do
    convert_to_csv(file)
    count_visible_trees(file <> ".csv")
  end

  def convert_to_csv(file) do
    converted =
      case File.read(file) do
        {:ok, content} ->
          content
          |> String.split("\n", trim: true)
          |> Enum.map(fn line ->
            String.split(line, "", trim: true)
            |> Enum.join(",")
          end)
          |> Enum.join("\n")
      end

    File.write(file <> ".csv", converted)
  end

  def count_visible_trees(file) do
    m = Matrex.load(file)

    nrows = m[:rows]
    ncols = m[:columns]

    counts =
      Matrex.apply(m, fn el, i, j ->
        if is_outer(i, j, nrows, ncols) do
          1
        else
          # Must be taller than one of: all elements on its right, all on its left,
          #  all above, all below.
          row = Matrex.row(m, i) |> Matrex.to_list()
          col = Matrex.column(m, j) |> Matrex.to_list()

          left = Enum.take(row, j - 1)
          right = Enum.take(row, -(length(row) - j))
          top = Enum.take(col, i - 1)
          bottom = Enum.take(col, -(length(col) - i))

          if el > Enum.max(left) || el > Enum.max(right) || el > Enum.max(bottom) ||
               el > Enum.max(top) do
            1
          else
            0
          end
        end
      end)

    round(Matrex.sum(counts))
  end

  def is_outer(i, j, nrows, ncols) do
    i == 1 || j == 1 || i == nrows || j == ncols
  end
end
