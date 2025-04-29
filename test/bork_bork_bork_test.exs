defmodule BorkBorkBorkTest do
  use ExUnit.Case
  doctest BorkBorkBork

  test "greets the world" do
    assert BorkBorkBork.hello() == :world
  end
end
