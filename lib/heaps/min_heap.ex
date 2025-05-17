defmodule MinHeap do
  @moduledoc """
  MinHeap data structure.
  """
  @behaviour Heap
  defstruct data: {}, size: 0

  @type t :: %MinHeap{data: tuple(), size: non_neg_integer()}

  def new(v), do: %MinHeap{data: {v}, size: 1}

  def insert(nil, x), do: new(x)

  def insert(heap, elem) do
    data = Tuple.insert_at(heap.data, heap.size, elem)
    size = heap.size + 1
    new_heap = %MinHeap{data: data, size: size}
    heapify(new_heap, size - 1)
  end

  def pop(%MinHeap{size: 0} = heap), do: {nil, heap}

  def pop(%MinHeap{data: data, size: size}) do
    min = elem(data, 0)

    last = elem(data, size - 1)
    data = put_elem(data, 0, last)
    data = Tuple.delete_at(data, size - 1)

    new_heap = %MinHeap{data: data, size: size - 1}

    if new_heap.size == 0 do
      {min, new_heap}
    else
      {min, balance(new_heap, 0)}
    end
  end

  def balance(heap, index) do
    {{left, l}, {right, r}} = get_children(heap, index)

    {value, v_index} =
      cond do
        left == nil and right == nil ->
          {nil, nil}

        right == nil ->
          {left, l}

        left == nil ->
          {right, r}

        left <= right ->
          {left, l}

        true ->
          {right, r}
      end

    current = elem(heap.data, index)

    cond do
      value == nil || value > current ->
        heap

      true ->
        data = swap(heap.data, index, v_index)
        new_heap = %MinHeap{data: data, size: heap.size}
        balance(new_heap, v_index)
    end
  end

  defp heapify(heap, index) do
    if index == 0 do
      heap
    else
      parent_index = div(index - 1, 2)

      if elem(heap.data, index) < elem(heap.data, parent_index) do
        data = swap(heap.data, parent_index, index)
        heapify(%MinHeap{data: data, size: heap.size}, parent_index)
      else
        heap
      end
    end
  end

  defp get_children(%MinHeap{data: data, size: size}, index) do
    l = index * 2 + 1
    r = index * 2 + 2

    left = if l < size, do: elem(data, l), else: nil
    right = if r < size, do: elem(data, r), else: nil

    {{left, l}, {right, r}}
  end

  defp swap(tuple, i, j) do
    list = Tuple.to_list(tuple)
    list = List.replace_at(list, i, elem(tuple, j))
    list = List.replace_at(list, j, elem(tuple, i))
    List.to_tuple(list)
  end
end

defimpl Heap, for: MinHeap do
  def new(v), do: MinHeap.new(v)
  def insert(heap, x), do: MinHeap.insert(heap, x)
  def pop(heap), do: MinHeap.pop(heap)
end
