defmodule BorkBorkBork.Models.Recipe do
  @moduledoc """
  Represents a complete recipe with metadata, ingredients, cookware, and steps.
  """

  alias BorkBorkBork.Models.{Ingredient, Cookware, Timer, Section}

  defstruct metadata: %{"map" => %{}},
            ingredients: [],
            cookware: [],
            sections: [],
            timers: [],
            inline_quantities: [],
            data: []

  @type t :: %__MODULE__{
          metadata: %{String.t() => any()},
          ingredients: list(Ingredient.t()),
          cookware: list(Cookware.t()),
          sections: list(Section.t()),
          timers: list(Timer.t()),
          inline_quantities: list(any()),
          data: list(any())
        }

  @doc """
  Creates a new Recipe from the provided map.
  """
  def from_map(map) do
    %__MODULE__{
      metadata: map["metadata"] || %{"map" => %{}},
      ingredients:
        (map["ingredients"] || [])
        |> Enum.map(&Ingredient.from_map/1),
      cookware:
        (map["cookware"] || [])
        |> Enum.map(&Cookware.from_map/1),
      sections:
        (map["sections"] || [])
        |> Enum.map(&Section.from_map/1),
      timers:
        (map["timers"] || [])
        |> Enum.map(&Timer.from_map/1),
      inline_quantities: map["inline_quantities"] || [],
      data: map["data"] || []
    }
  end

  @doc """
  Creates a new empty recipe.
  """
  def new do
    %__MODULE__{
      metadata: %{"map" => %{}},
      ingredients: [],
      cookware: [],
      sections: [Section.new()],
      timers: [],
      inline_quantities: [],
      data: []
    }
  end

  @doc """
  Adds an ingredient to the recipe.
  """
  def add_ingredient(recipe, ingredient) do
    %{recipe | ingredients: recipe.ingredients ++ [ingredient]}
  end

  @doc """
  Adds cookware to the recipe.
  """
  def add_cookware(recipe, cookware) do
    %{recipe | cookware: recipe.cookware ++ [cookware]}
  end

  @doc """
  Adds a timer to the recipe.
  """
  def add_timer(recipe, timer) do
    %{recipe | timers: recipe.timers ++ [timer]}
  end

  @doc """
  Converts the struct to a map that matches the expected output format.
  """
  def to_map(%__MODULE__{} = recipe) do
    %{
      "metadata" => recipe.metadata,
      "ingredients" => Enum.map(recipe.ingredients, &Ingredient.to_map/1),
      "cookware" => Enum.map(recipe.cookware, &Cookware.to_map/1),
      "sections" => Enum.map(recipe.sections, &Section.to_map/1),
      "timers" => Enum.map(recipe.timers, &Timer.to_map/1),
      "inline_quantities" => recipe.inline_quantities,
      "data" => recipe.data
    }
  end
  
  # For backward compatibility with map inputs
  def to_map(recipe) when is_map(recipe) do
    recipe
  end
end
