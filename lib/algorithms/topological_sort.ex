defmodule TopologicalSort do
  def topological_sort(graph) do
    indegrees = %{}
    queue = :queue.new()
    result = []
    result = Enum.reverse(do_topological_sort(graph, indegrees, queue, result))

    if map_size(graph) !== length(result) do
      []
    else
      result
    end
  end

  defp do_topological_sort(graph, indegrees, queue, result) do
    indegrees = compute_indegrees(graph, indegrees)

    queue =
      Enum.reduce(graph, queue, fn {node, _}, acc ->
        if !Map.has_key?(indegrees, node), do: :queue.in(node, acc), else: acc
      end)

    loop_queue(graph, indegrees, queue, result)
  end

  defp loop_queue(graph, indegrees, queue, result) do
    case :queue.out(queue) do
      {{:value, node}, new_queue} ->
        result = [node | result]

        {new_indegrees, new_queue2} =
          update_indegrees(
            node,
            graph,
            indegrees,
            new_queue
          )

        loop_queue(graph, new_indegrees, new_queue2, result)

      {:empty, _} ->
        result
    end
  end

  defp update_indegrees(node, graph, indegrees, queue) do
    edges = Map.get(graph, node, [])

    Enum.reduce(edges, {indegrees, queue}, fn %{to: target}, {acc_indegrees, acc_queue} ->
      new_val = Map.get(acc_indegrees, target, 1) - 1

      if new_val == 0 do
        {
          Map.delete(acc_indegrees, target),
          :queue.in(target, acc_queue)
        }
      else
        {
          Map.put(acc_indegrees, target, new_val),
          acc_queue
        }
      end
    end)
  end

  defp compute_indegrees(graph, indegrees) do
    Enum.reduce(graph, indegrees, fn {_, edges}, acc ->
      Enum.reduce(edges, acc, fn %{to: target}, acc2 ->
        Map.update(acc2, target, 1, &(&1 + 1))
      end)
    end)
  end
end
