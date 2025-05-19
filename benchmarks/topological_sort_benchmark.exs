graph = %{
  a: [%{to: :b, cost: 1}, %{to: :c, cost: 4}, %{to: :e, cost: 7}],
  b: [%{to: :c, cost: 2}, %{to: :d, cost: 5}, %{to: :f, cost: 3}],
  c: [%{to: :d, cost: 1}, %{to: :g, cost: 8}],
  d: [%{to: :h, cost: 2}],
  e: [%{to: :f, cost: 1}, %{to: :i, cost: 6}],
  f: [%{to: :g, cost: 1}, %{to: :j, cost: 4}],
  g: [%{to: :h, cost: 1}],
  h: [%{to: :j, cost: 3}],
  i: [%{to: :j, cost: 1}],
  j: []
}

Benchee.run(
  %{
    "Topological sort" => fn ->
      TopologicalSort.topological_sort(graph)
    end,
    "Topological sort 2" => fn ->
      TopologicalSortTwo.topological_sort(graph)
    end
  },
  time: 30,
  warmup: 10,
  memory_time: 2
)
