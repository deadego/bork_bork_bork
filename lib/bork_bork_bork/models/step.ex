defmodule BorkBorkBork.Models.Step do
  @moduledoc """
  Represents a step in a recipe with text and references to ingredients, cookware, and timers.
  """

  defstruct type: "step",
            value: %{
              "items" => [],
              "number" => 1
            }

  @type t :: %__MODULE__{
          type: String.t(),
          value: map()
        }

  @doc """
  Creates a new Step from the provided map.
  """
  def from_map(map) do
    struct(__MODULE__, map)
  end

  @doc """
  Creates a new empty step with the specified number.
  """
  def new(number) do
    %__MODULE__{
      type: "step",
      value: %{
        "items" => [],
        "number" => number
      }
    }
  end

  @doc """
  Adds an item to the step.
  """
  def add_item(step, item) do
    items = get_in(step, [:value, "items"]) || []
    put_in(step, [:value, "items"], items ++ [item])
  end

  @doc """
  Converts the struct to a map that matches the expected output format.
  """
  def to_map(step) do
    Map.from_struct(step)
  end
end
