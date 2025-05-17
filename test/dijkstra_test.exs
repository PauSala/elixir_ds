defmodule DijkstraTest do
  use ExUnit.Case
  doctest Dijkstra

  test "Existing path from a to d" do
    graph = %{
      a: [%{to: :b, cost: 1}, %{to: :c, cost: 4}],
      b: [%{to: :c, cost: 2}, %{to: :d, cost: 5}],
      c: [%{to: :d, cost: 1}],
      d: []
    }

    assert Dijkstra.shortest_path(graph, :a, :d) == {:ok, 4, [:a, :b, :c, :d]}

    graph = %{
      a: [%{to: :b, cost: 0}, %{to: :c, cost: 0}],
      b: [%{to: :c, cost: 0}, %{to: :d, cost: 0}],
      c: [%{to: :d, cost: 0}],
      d: []
    }

    assert Dijkstra.shortest_path(graph, :a, :d) == {:ok, 0, [:a, :b, :d]}
  end

  test "Non existing path from a to d" do
    graph = %{
      a: [],
      d: []
    }

    assert Dijkstra.shortest_path(graph, :a, :d) == nil
  end

  test "MinHeap" do
    graph = %{
      a: [%{to: :b, cost: 1}, %{to: :c, cost: 4}],
      b: [%{to: :c, cost: 2}, %{to: :d, cost: 5}],
      c: [%{to: :d, cost: 1}],
      d: []
    }

    assert Dijkstra.shortest_path(graph, :a, :d, MinHeap) == {:ok, 4, [:a, :b, :c, :d]}
  end
end
