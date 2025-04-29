defmodule BorkBorkBork do
  alias BorkBorkBork.Parser

  # Parse a cooklang recipe string into structured data
  def parse(input) do
    # Extract metadata from YAML front matter if present
    {metadata, content} = extract_metadata(input)

    # Parse the recipe content
    case Parser.parse(content) do
      {:ok, result} ->
        # Add the metadata to the result
        result = put_in(result, ["metadata", "map"], metadata)
        {:ok, result}

      error ->
        error
    end
  end

  # Extract YAML metadata from the front matter
  defp extract_metadata(input) do
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

  # Parse YAML metadata
  defp parse_yaml_metadata(yaml_str) do
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
