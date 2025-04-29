defmodule BorkBorkBork.Recipe do
  @moduledoc """
  Functions for working with Cooklang recipes.
  """

  alias BorkBorkBork.Models.Recipe

  alias BorkBorkBork.Parser
  alias BorkBorkBork.Parser_New

  @doc """
  Parses a recipe string into a Recipe struct.
  """
  def parse(input) do
    # Extract metadata from YAML front matter if present
    {metadata, content} = extract_metadata(input)

    # Parse the recipe content
    case Parser_New.parse(content) do
      {:ok, recipe = %Recipe{}} ->
        # Add the metadata to the recipe
        recipe = %{recipe | metadata: %{"map" => metadata}}
        {:ok, recipe}

      _error ->
        # Fallback to legacy parser for backward compatibility
        case Parser.parse(content) do
          {:ok, recipe_map} ->
            # Convert to struct and add the metadata
            recipe = 
              Recipe.from_map(recipe_map)
              |> Map.put(:metadata, %{"map" => metadata})
            
            {:ok, recipe}
            
          parse_error -> 
            parse_error
        end
    end
  end

  @doc """
  Converts a Recipe struct to a map.
  """
  def to_map(recipe) do
    Recipe.to_map(recipe)
  end

  @doc """
  Extracts YAML metadata from the front matter.
  """
  def extract_metadata(input) do
    case Regex.run(~r/^---\s*\n(.*?)\n\s*---\s*\n(.*)/s, input) do
      [_, yaml_str, content] ->
        # Parse the YAML metadata
        metadata = parse_yaml_metadata(yaml_str)
        {metadata, content}

      _ ->
        # No metadata found
        {%{}, input}
    end
  end

  @doc """
  Parses YAML metadata from a string.
  """
  def parse_yaml_metadata(yaml_str) do
    # Parse YAML metadata from string
    yaml_str
    |> String.split("\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(String.length(&1) == 0))
    |> Enum.map(fn line ->
      case String.split(line, ":", parts: 2) do
        [key, value] ->
          clean_value =
            value
            |> String.trim()
            |> String.trim_leading("'")
            |> String.trim_trailing("'")
            |> String.trim_leading("\"")
            |> String.trim_trailing("\"")

          # Handle list values like [item1, item2]
          final_value =
            if String.match?(clean_value, ~r/^\[.*\]$/) do
              # Extract items between brackets and split by comma
              clean_value
              # Remove outer brackets
              |> String.slice(1..(String.length(clean_value) - 2))
              |> String.split(",")
              |> Enum.map(&String.trim/1)
            else
              clean_value
            end

          {String.trim(key), final_value}

        _ ->
          nil
      end
    end)
    |> Enum.reject(&is_nil/1)
    |> Map.new()
  end
end
