defmodule DsTest do
  use ExUnit.Case
  doctest Ds

  test "greets the world" do
    assert Ds.hello() == :world
  end
end
