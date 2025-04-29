defmodule BorkBorkBork.Models.Quantity do
  @moduledoc """
  Represents a quantity for an ingredient or timer with a value and unit.
  """

  defstruct unit: nil,
            value: nil

  @type t :: %__MODULE__{
          unit: nil | String.t(),
          value: nil | map()
        }

  @doc """
  Creates a new Quantity from the provided map.
  """
  def from_map(nil), do: nil

  def from_map(map) do
    struct(__MODULE__, map)
  end

  @doc """
  Creates a new quantity with the specified unit and value.
  """
  def new(value, unit) do
    %__MODULE__{
      unit: unit,
      value: parse_value(value)
    }
  end

  @doc """
  Parses a value string into a structured value map.
  """
  def parse_value(nil), do: nil
  def parse_value(""), do: nil

  def parse_value(value) when is_binary(value) do
    cond do
      # Looks like a fraction (e.g., "3/4")
      String.contains?(value, "/") ->
        parse_fraction(value)

      # Looks like a number
      Regex.match?(~r/^\d+(\.\d+)?$/, value) ->
        {num, _} = value |> String.trim() |> Float.parse()

        %{
          "type" => "fixed",
          "value" => %{
            "type" => "number",
            "value" => %{"type" => "regular", "value" => num}
          }
        }

      # Otherwise, treat as text
      true ->
        %{
          "type" => "fixed",
          "value" => %{"type" => "text", "value" => value}
        }
    end
  end

  def parse_value(value) when is_number(value) do
    %{
      "type" => "fixed",
      "value" => %{
        "type" => "number",
        "value" => %{"type" => "regular", "value" => value * 1.0}
      }
    }
  end

  def parse_value(_), do: nil

  @doc """
  Parses a fraction string into a structured value map.
  """
  def parse_fraction(fraction_str) do
    case String.split(fraction_str, "/") do
      [num, den] ->
        {num_int, ""} = Integer.parse(String.trim(num))
        {den_int, ""} = Integer.parse(String.trim(den))

        %{
          "type" => "fixed",
          "value" => %{
            "type" => "number",
            "value" => %{
              "type" => "fraction",
              "value" => %{"num" => num_int, "den" => den_int, "whole" => 0, "err" => 0.0}
            }
          }
        }

      _ ->
        %{
          "type" => "fixed",
          "value" => %{"type" => "text", "value" => fraction_str}
        }
    end
  end

  @doc """
  Converts the struct to a map that matches the expected output format.
  """
  def to_map(nil), do: nil
  def to_map(quantity), do: Map.from_struct(quantity)
end
