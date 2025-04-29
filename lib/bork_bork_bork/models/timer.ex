defmodule BorkBorkBork.Models.Timer do
  @moduledoc """
  Represents a timer for a cooking step with a duration.
  """

  defstruct name: nil,
            quantity: nil

  @type t :: %__MODULE__{
          name: nil | String.t(),
          quantity: nil | %{String.t() => any()}
        }

  @doc """
  Creates a new Timer from the provided map.
  """
  def from_map(map) do
    struct(__MODULE__, map)
  end

  @doc """
  Converts the struct to a map that matches the expected output format.
  """
  def to_map(timer) do
    Map.from_struct(timer)
  end
end
