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
    |> Enum.filter(fn sz -> sz <= 100_000 end)
    # |> IO.inspect
    |> Enum.reduce(fn x, acc -> acc + x end)
  end

  defp add_dir_as_child(graph, stack, dir) do
    node = get_in(graph, [dir])

    if is_nil(node) do
      # IO.puts("Attaching directory `#{x}` to current node")

      # Do two things:
      # 1. create new vertex in the graph
      # 2. add the new vertex's label to the children of the deepest directory in the stack
      new_vertex = %GraphNode{label: "#{dir}", size: nil, children: []}
      graph_with_new_vertex = put_in(graph, [dir], new_vertex)

      add_child(stack, graph_with_new_vertex, dir)
    else
      graph
    end
  end

  defp parse_instruction([first_instruction | rest], stack, graph) do
    case String.split(first_instruction) do
      ["$", "cd", ".."] ->
        new_stack =
          stack
          |> List.pop_at(-1)
          |> elem(1)

        parse_instruction(rest, new_stack, graph)

      ["$", "cd", x] ->
        new_graph = add_dir_as_child(graph, stack, x)
        parse_instruction(rest, stack ++ [x], new_graph)

      ["$", "ls"] ->
        # Just skip.
        parse_instruction(rest, stack, graph)

      ["dir", dir_name] ->
        new_graph = add_dir_as_child(graph, stack, dir_name)
        parse_instruction(rest, stack, new_graph)

      [size, file_name] ->
        graph_with_new_vertex =
          put_in(graph, [file_name], %GraphNode{
            label: file_name,
            size: String.to_integer(size),
            children: []
          })

        new_graph = add_child(stack, graph_with_new_vertex, file_name)

        parse_instruction(rest, stack, new_graph)
    end
  end

  defp parse_instruction([], _stack, graph) do
    graph
  end

  defp add_child(stack, graph, child) do
    cur_dir = Enum.at(stack, -1)

    unless is_nil(cur_dir) do
      cur_dir_node = Map.get(graph, cur_dir)
      updated_cur_dir_node = %{cur_dir_node | children: cur_dir_node.children ++ [child]}
      Map.put(graph, cur_dir, updated_cur_dir_node)
    else
      graph
    end
  end
end
