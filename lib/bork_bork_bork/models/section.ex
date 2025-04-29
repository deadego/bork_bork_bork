defmodule BorkBorkBork.Models.Section do
  @moduledoc """
  Represents a section in a recipe, which is a group of steps.
  """

  alias BorkBorkBork.Models.Step

  defstruct name: nil,
            content: []

  @type t :: %__MODULE__{
          name: nil | String.t(),
          content: list(Step.t())
        }

  @doc """
  Creates a new Section from the provided map.
  """
  def from_map(map) do
    struct(__MODULE__, map)
  end

  @doc """
  Creates a new empty section with the specified name.
  """
  def new(name \\ nil) do
    %__MODULE__{
      name: name,
      content: []
    }
  end

  @doc """
  Adds a step to the section.
  """
  def add_step(section, step) do
    %{section | content: section.content ++ [step]}
  end

  @doc """
  Converts the struct to a map that matches the expected output format.
  """
  def to_map(section) do
    map = Map.from_struct(section)
    %{map | content: Enum.map(section.content, &Step.to_map/1)}
  end
end
