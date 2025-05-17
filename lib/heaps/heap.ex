defprotocol Heap do
  @doc "Insert an element into the heap"
  def insert(heap, value)

  @doc "Pop the minimum element from the heap"
  def pop(heap)

  @doc "Create a new heap with a single value"
  def new(value)
end
