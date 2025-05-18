defmodule TopologicalSortTest do
  use ExUnit.Case
  doctest TopologicalSort

  test "Topological Sort trivial" do
    graph = %{
      a: [%{to: :b}],
      b: [%{to: :c}],
      c: [%{to: :d}],
      d: []
    }

    assert TopologicalSort.topological_sort(graph) == [:a, :b, :c, :d]
  end

  test "Topological Sort" do
    graph = %{
      a: [%{to: :b}, %{to: :c}],
      b: [%{to: :d}],
      c: [%{to: :b}],
      d: []
    }

    assert TopologicalSort.topological_sort(graph) == [:a, :c, :b, :d]
  end

  test "Topological Sort cycle" do
    graph = %{
      A: [%{to: :a}],
      a: [%{to: :b}],
      b: [%{to: :c}],
      c: [%{to: :a}]
    }

    assert TopologicalSort.topological_sort(graph) == []
  end
end
