defmodule BorkBorkBork do
  @moduledoc """
  BorkBorkBork is a parser for Cooklang recipes.
  """

  alias BorkBorkBork.Recipe

  @doc """
  Parses a Cooklang recipe string into a structured format.

  ## Parameters

  - `input` - The recipe string in Cooklang format

  ## Returns

  - `{:ok, result}` - A map representation of the parsed recipe
  - `{:error, reason}` - An error tuple with the reason
  """
  def parse(input) do
    # For backward compatibility with tests, use the original parser directly
    case BorkBorkBork.Parser.parse(input) do
      {:ok, result} ->
        # Extract metadata from YAML front matter if present
        {metadata, _} = Recipe.extract_metadata(input)

        # Add the metadata to the result
        result = put_in(result, ["metadata", "map"], metadata)
        {:ok, result}

      error ->
        # If that fails, try the new struct-based parser
        case Recipe.parse(input) do
          {:ok, recipe} ->
            # Convert the Recipe struct to a map for API compatibility
            {:ok, Recipe.to_map(recipe)}

          _ ->
            error
        end
    end
  end

  @doc """
  Parses a Cooklang recipe string and returns a Recipe struct instead of a plain map.

  This is useful when you want to work with the Recipe struct directly.

  ## Parameters

  - `input` - The recipe string in Cooklang format

  ## Returns

  - `{:ok, recipe}` - A Recipe struct representing the parsed recipe
  - `{:error, reason}` - An error tuple with the reason
  """
  def parse_to_struct(input) do
    Recipe.parse(input)
  end
end
