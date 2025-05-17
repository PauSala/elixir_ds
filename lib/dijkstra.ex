defmodule Dijkstra do
  @type tnode :: atom() | String.t() | integer()
  @type edge :: %{to: tnode(), cost: number()}
  @type graph :: %{required(tnode()) => [edge()]}

  def shortest_path(graph, s, e, heap_mod \\ LHeap) do
    distances = %{s => 0}
    visited = MapSet.new()
    heap = heap_mod.new({0, s, [s]})
    do_dijkstra(graph, heap, distances, visited, e, heap_mod)
  end

  defp do_dijkstra(graph, heap, distances, visited, goal, heap_mod) do
    case heap_mod.pop(heap) do
      {nil, _heap} ->
        nil

      {{dist, node, path}, new_heap} ->
        if node == goal do
          {:ok, dist, Enum.reverse(path)}
        else
          if MapSet.member?(visited, node) do
            do_dijkstra(graph, new_heap, distances, visited, goal, heap_mod)
          else
            visited = MapSet.put(visited, node)

            {new_heap, new_distances} =
              visit_neighbors(
                graph,
                node,
                path,
                dist,
                visited,
                distances,
                new_heap,
                heap_mod
              )

            do_dijkstra(graph, new_heap, new_distances, visited, goal, heap_mod)
          end
        end
    end
  end

  defp visit_neighbors(
         graph,
         node,
         path,
         dist,
         visited,
         distances,
         heap,
         heap_mod
       ) do
    Enum.reduce(
      graph[node] || [],
      {heap, distances},
      fn %{to: neighbor, cost: cost}, {h, d} ->
        if MapSet.member?(visited, neighbor) do
          {h, d}
        else
          old_dist = Map.get(d, neighbor, :infinity)
          new_dist = dist + cost

          if new_dist < old_dist do
            new_path = [neighbor | path]

            {
              heap_mod.insert(h, {new_dist, neighbor, new_path}),
              Map.put(d, neighbor, new_dist)
            }
          else
            {h, d}
          end
        end
      end
    )
  end
end
