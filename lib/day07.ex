defmodule Day07 do
  def solve(file, part) do
    parser =
      case part do
        :one ->
          &parse_instruction/3

        _ ->
          IO.puts("Not implemented")
          exit(:unimplemented)
      end

    compute = &add_smaller_sizes/1

    case File.read(file) do
      {:ok, content} ->
        content
        |> String.split("\n", trim: true)
        |> parser.([], %{})
        |> compute.()
    end
  end

  defp add_smaller_sizes(graph) do
    graph
    |> Enum.map(fn {vertex, node} ->
      unless Enum.empty?(node.children) do
        GraphNode.size(vertex, graph)
      else
        # Don't consider files (nodes with no children)
        0
      end
    end)
    |> Enum.filter(fn sz -> sz > 0 && sz <= 100_000 end)
    # |> IO.inspect
    |> Enum.reduce(fn x, acc -> acc + x end)
  end

  defp parse_instruction([first_instruction | rest], stack, graph) do
    IO.puts("Parsing '#{first_instruction}'...")

    case String.split(first_instruction) do
      ["$", "cd", ".."] ->
        new_stack = Enum.drop(stack, -1)
        parse_instruction(rest, new_stack, graph)

      ["$", "cd", x] ->
        IO.puts("adding `#{x}` to the stack...")
        IO.inspect(stack)

        parent_label = Enum.join(stack, ",")

        parent_node =
          if Enum.empty?(stack) do
            GraphNode.add_child(GraphNode.new(), x)
          else
            parent = graph[parent_label]
            GraphNode.add_child(parent, x)
          end

        parse_instruction(rest, stack ++ [x], Map.merge(%{parent_label => parent_node, x => GraphNode.new()}, graph))

      ["$", "ls"] ->
        # Just skip.
        parse_instruction(rest, stack, graph)

      ["dir", _dir] ->
        # IO.puts("adding dir `#{_dir}`")
        # IO.write("stack is: ")
        # IO.inspect(stack)
        # IO.write("graph: ")
        # IO.inspect(graph)

        parse_instruction(rest, stack, graph)

      [size, file_name] ->
        label = Enum.join(stack ++ [file_name], ",")
        graph_with_new_vertex = Map.put(graph, label, GraphNode.new(size))

        new_graph = update_children_of_cur_dir(graph_with_new_vertex, stack, file_name)

        parse_instruction(rest, stack, new_graph)

      _ ->
        IO.puts("ERROR: Unrecognized instruction")
    end
  end

  defp parse_instruction([], _stack, graph) do
    graph
  end

  # Adds the node as one of the children to the current dir GraphNode in the `graph` map.
  defp update_children_of_cur_dir(graph, stack, child) do
    cur_dir = Enum.at(stack, -1)

    if cur_dir do
      label = Enum.join(stack ++ [cur_dir], ",")
      # TODO(gianluca): Remove when done
      IO.puts("""
      \n------------@@@> #{__MODULE__} | #{elem(__ENV__.function, 0)}:#{__ENV__.line}
      - label: #{inspect(label, pretty: true)}
      """)

      cur_dir_node = graph[label]
      updated_cur_dir_node = GraphNode.add_child(cur_dir_node, child)
      Map.put(graph, cur_dir, updated_cur_dir_node)
    else
      # this should be the only child... does this happen?
      IO.puts("-------ERROR: Adding child but no current directory...")
      graph
    end
  end
end
