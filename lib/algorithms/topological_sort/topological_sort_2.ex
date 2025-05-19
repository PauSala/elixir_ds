defmodule TopologicalSortTwo do
  def topological_sort(graph) do
    indegrees = compute_indegrees(graph)
    # Get ALL nodes from graph keys + target nodes from edges
    all_nodes = Map.keys(graph) |> Enum.uniq()
    queue = initialize_queue(all_nodes, indegrees)
    process_queue(graph, indegrees, queue, [])
  end

  defp initialize_queue(all_nodes, indegrees) do
    Enum.reduce(all_nodes, :queue.new(), fn node, acc ->
      if Map.get(indegrees, node, 0) == 0, do: :queue.in(node, acc), else: acc
    end)
  end

  defp process_queue(graph, indegrees, queue, result) do
    case :queue.out(queue) do
      {{:value, node}, new_queue} ->
        {updated_indegrees, updated_queue} = update_dependents(graph, node, indegrees, new_queue)
        process_queue(graph, updated_indegrees, updated_queue, [node | result])

      {:empty, _} ->
        if length(result) == map_size(graph), do: Enum.reverse(result), else: []
    end
  end

  defp update_dependents(graph, node, indegrees, queue) do
    Enum.reduce(graph[node] || [], {indegrees, queue}, fn %{to: to}, {indegrees, queue} ->
      new_indegree = Map.get(indegrees, to, 0) - 1
      indegrees = Map.put(indegrees, to, new_indegree)

      if new_indegree == 0 do
        {indegrees, :queue.in(to, queue)}
      else
        {indegrees, queue}
      end
    end)
  end

  defp compute_indegrees(graph) do
    Enum.reduce(graph, %{}, fn {_node, edges}, acc ->
      Enum.reduce(edges, acc, fn %{to: to}, acc ->
        Map.update(acc, to, 1, &(&1 + 1))
      end)
    end)
  end
end
