defmodule Day07 do
  def solve(file, part) do
    fun =
      case part do
        :one -> &parse_instruction/4
      end

    case File.read(file) do
      {:ok, content} ->
        content
        |> String.split("\n", trim: true)
        |> fun.([], %{}, MapSet.new())
    end
  end

  @doc """
    Transforms the list of instructions into an Elixir map. Each node's value in the map is either
    a size (for files) or another map (for directories). Fox example, the parsing of day07.sample.txt
    is:
    ```
      %{
        "/" => %{
          "a" => %{"e" => %{"i" => 584}, "f" => 29116, "g" => 2557, "h.lst" => 62596},
          "b.txt" => 14848514,
          "c.dat" => 8504156,
          "d" => %{
            "d.ext" => 5626152,
            "d.log" => 8033020,
            "j" => 4060174,
            "k" => 7214296
          }
        }
      }
    ```

    As a side-effect, it produces paths to directories inside dir_paths:
    ```
    #MapSet<[["/"], ["/", "a"], ["/", "a", "e"], ["/", "d"]]>
    ```
  """
  def parse_instruction([first_instruction | rest], stack, graph, dir_paths) do
    case String.split(first_instruction) do
      ["$", "cd", ".."] ->
        new_stack =
          stack
          |> List.pop_at(-1)
          |> elem(1)

        parse_instruction(rest, new_stack, graph, dir_paths)

      ["$", "cd", x] ->
        new_graph =
          if is_nil(get_in(graph, stack ++ [x])) do
            # IO.puts("Attaching directory #{x} to current node")
            put_in(graph, stack ++ [x], %{})
          else
            graph
          end

        parse_instruction(rest, stack ++ [x], new_graph, MapSet.put(dir_paths, stack ++ [x]))

      ["$", "ls"] ->
        parse_instruction(rest, stack, graph, dir_paths)

      ["dir", dir_name] ->
        # IO.puts("Attaching directory #{dir_name} to current node")
        new_graph =
          if is_nil(get_in(graph, stack ++ [dir_name])) do
            put_in(graph, stack ++ [dir_name], %{})
          else
            graph
          end

        parse_instruction(rest, stack, new_graph, MapSet.put(dir_paths, stack ++ [dir_name]))

      [size, file_name] ->
        # IO.puts("#{file_name} has size #{String.to_integer(size)}")
        new_graph = put_in(graph, stack ++ [file_name], String.to_integer(size))
        parse_instruction(rest, stack, new_graph, dir_paths)
    end
  end

  def parse_instruction([], _stack, graph, dir_paths) do
    IO.write("final graph: ")
    IO.inspect(graph)

    res = 0 #compute_size(graph, dir_paths, MapSet.new(), %{})

    IO.write("res: ")
    IO.inspect(res)

    res
  end

  @doc """
    A `path` is an array of the directory making up the path, e.g. `["/", "a", "b", "c"]` mean
    "/a/b/c".

    `n` is a path.
    `sizes` is a map `path => size`.

    iex> Day07.processed?(["a", "b", "c"], %{["a", "b", "c"] => 1})
    true
    iex> Day07.processed?(["a", "b"], %{["a", "b", "c"] => 1})
    false
  """
  def processed?(n, sizes) do
    Map.has_key?(sizes, n)
  end

  # FIXME(gianluca):
  @doc """
    What's the size of path?

    A `path` is an array of the directory making up the path, e.g. `["/", "a", "b", "c"]` mean
    "/a/b/c".
    `graph` is the whole map of directories and children.
    `children` is a map between a path and its direct children.
    `sizes` is a map between a directory and its size.

    iex> Day07.compute_size(["/"], %{
    ...>    "/" => %{
    ...>      "a" => %{"e" => %{"i" => 584}, "f" => 29116, "g" => 2557, "h.lst" => 62596},
    ...>      "b.txt" => 14848514,
    ...>      "c.dat" => 8504156,
    ...>      "d" => %{
    ...>        "d.ext" => 5626152,
    ...>        "d.log" => 8033020,
    ...>        "j" => 4060174,
    ...>        "k" => 7214296
    ...>      }
    ...>    }
    ...>  }, %{
    ...>    ["/"] => ["a", "b.txt", "c.dat", "d"],
    ...>    ["/", "a"] => ["e", "f", "g", "h.lst"],
    ...>    ["/", "a", "e"] => ["i"],
    ...>    ["/", "d"] => ["d.ext", "d.log", "j", "k"]
    ...>  }, %{})
    %{["/"] => 48381165}
  """
  def compute_size(path, graph, children, sizes) do
    if is_nil(Map.get(children, path)) do
      # TODO(gianluca): Remove when done
      IO.puts("""
      \n------------@@@> #{__MODULE__} | #{elem(__ENV__.function, 0)}:#{__ENV__.line}
      ------ get_in(graph, path): #{inspect get_in(graph, path), pretty: true}
      """)
      # Map.put(sizes, path, get_in(graph, path))
      get_in(graph, path)
    else
      # TODO(gianluca): Remove when done
      IO.puts(" --------- #{__MODULE__}.#{elem(__ENV__.function, 0)}:#{__ENV__.line} I AM CALLED")

      # TODO(gianluca): Remove when done
      IO.puts("""
      \n------------@@@> #{__MODULE__} | #{elem(__ENV__.function, 0)}:#{__ENV__.line}
      - Map.get(children, path): #{inspect Map.get(children, path), pretty: true}
      """)


      size =
        Enum.reduce(Map.get(children, path), fn c, acc ->
          acc + compute_size(path ++ [c], graph, children, sizes)
        end)
      Map.put(sizes, path, size)
    end
  end
end
