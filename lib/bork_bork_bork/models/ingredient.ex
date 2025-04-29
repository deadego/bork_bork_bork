defmodule BorkBorkBork.Models.Ingredient do
  @moduledoc """
  Represents an ingredient in a recipe, with potential quantity, unit, and other properties.
  """

  defstruct name: nil,
            quantity: nil,
            alias: nil,
            note: nil,
            modifiers: "",
            relation: %{
              "defined_in_step" => true,
              "reference_target" => nil,
              "referenced_from" => [],
              "type" => "definition"
            }

  @type t :: %__MODULE__{
          name: String.t(),
          quantity: nil | %{String.t() => any()},
          alias: nil | String.t(),
          note: nil | String.t(),
          modifiers: String.t(),
          relation: %{String.t() => any()}
        }

  @doc """
  Creates a new Ingredient from the provided map.
  """
  def from_map(map) do
    struct(__MODULE__, map)
  end

  @doc """
  Converts the struct to a map that matches the expected output format.
  """
  def to_map(ingredient) do
    Map.from_struct(ingredient)
  end
end
