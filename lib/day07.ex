defmodule Day07 do
  def solve(file, part) do
    parser =
      case part do
        :one -> &parse_instruction/3
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

  defp add_dir_as_child(graph, stack, dir) do
    node = graph[dir]

    unless node do
      # Do two things:
      # 1. create new vertex in the graph
      graph_with_new_vertex = Map.put(graph, dir, GraphNode.new())

      # 2. add the new vertex's label to the children of the deepest directory in the stack
      cur_dir = Enum.at(stack, -1)
      # IO.puts("Attaching directory `#{dir}` to current node `#{cur_dir}`")
      update_children_of_cur_dir(cur_dir, graph_with_new_vertex, dir)
    else
      graph
    end
  end

  defp parse_instruction([first_instruction | rest], stack, graph) do
    # IO.puts("Parsing '#{first_instruction}'...")

    case String.split(first_instruction) do
      ["$", "cd", ".."] ->
        new_stack =
          stack
          |> List.pop_at(-1)
          |> elem(1)

        parse_instruction(rest, new_stack, graph)

      ["$", "cd", x] ->
        # IO.puts("adding `#{x}` to the stack...")

        parse_instruction(rest, stack ++ [x], Map.merge(%{x => GraphNode.new()}, graph))

      ["$", "ls"] ->
        # Just skip.
        parse_instruction(rest, stack, graph)

      ["dir", dir_name] ->
        # IO.puts("adding dir `#{dir_name}`")
        # IO.write("stack is: ")
        # IO.inspect(stack)
        # IO.write("graph: ")
        # IO.inspect(graph)

        new_graph = add_dir_as_child(graph, stack, dir_name)
        parse_instruction(rest, stack, new_graph)

      [size, file_name] ->
        graph_with_new_vertex = Map.put(graph, file_name, GraphNode.new(size))

        new_graph =
          update_children_of_cur_dir(Enum.at(stack, -1), graph_with_new_vertex, file_name)

        parse_instruction(rest, stack, new_graph)

      _ ->
        IO.puts("ERROR: Unrecognized instruction")
    end
  end

  defp parse_instruction([], _stack, graph) do
    graph
  end

  # Adds the node as one of the children to the current dir GraphNode in the `graph` map.
  defp update_children_of_cur_dir(cur_dir, graph, child) do
    if cur_dir do
      cur_dir_node = graph[cur_dir]
      updated_cur_dir_node = GraphNode.add_child(cur_dir_node, child)
      Map.put(graph, cur_dir, updated_cur_dir_node)
    else
      # this should be the only child... does this happen?
      IO.puts("-------ERROR: Adding child but no current directory...")
      graph
    end
  end
end
