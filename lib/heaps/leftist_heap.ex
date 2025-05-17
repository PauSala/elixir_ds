defmodule LHeap do
  @behaviour Heap
  defstruct rank: 0, v: nil, l: nil, r: nil

  @type t :: %__MODULE__{
          rank: non_neg_integer(),
          v: any(),
          l: t | nil,
          r: t | nil
        }

  def new(v), do: %LHeap{rank: 1, v: v, l: nil, r: nil}

  def insert(nil, x), do: new(x)
  def insert(heap, x), do: merge(new(x), heap)
  def pop(nil), do: {nil, nil}
  def pop(%LHeap{v: v} = heap), do: {v, merge(heap.l, heap.r)}

  defp merge(a, nil), do: a
  defp merge(nil, b), do: b

  defp merge(a, b) do
    {root, h2} = if a.v <= b.v, do: {a, b}, else: {b, a}
    right = merge(root.r, h2)
    left = root.l

    if rank(left) >= rank(right) do
      %LHeap{v: root.v, l: left, r: right, rank: 1 + rank(right)}
    else
      %LHeap{v: root.v, l: right, r: left, rank: 1 + rank(left)}
    end
  end

  defp rank(nil), do: 0
  defp rank(%LHeap{rank: r}), do: r
end

defimpl Heap, for: LHeap do
  def new(v), do: LHeap.new(v)
  def insert(heap, x), do: LHeap.insert(heap, x)
  def pop(heap), do: LHeap.pop(heap)
end
