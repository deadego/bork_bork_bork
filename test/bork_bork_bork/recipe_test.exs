defmodule BorkBorkBork.RecipeTest do
  use ExUnit.Case

  alias BorkBorkBork.Models.{
    Recipe,
    Ingredient,
    Cookware,
    Timer,
    Section,
    Step,
    Quantity
  }

  test "parse recipe with new struct-based implementation" do
    input = """
    ---
    title: Simple Pasta
    source: https://example.com
    servings: 2
    tags: [pasta, easy, quick]
    ---

    Bring a #pot{} of water to boil. Add salt to taste.

    Add @pasta{250%g} to the water and cook for ~{8%minutes} until al dente.

    Meanwhile, heat @olive oil{2%tbsp} in a #pan{}.

    -- This is a comment that should be ignored

    Add @garlic{2%cloves, minced} and cook until fragrant.

    Drain the pasta and add it to the pan. Toss to combine.

    Serve with @parmesan{} and @black pepper{} to taste.
    """

    {:ok, recipe} = BorkBorkBork.parse_to_struct(input)

    # Test basic recipe structure
    assert %Recipe{} = recipe
    assert length(recipe.ingredients) == 5
    assert length(recipe.cookware) == 2
    assert length(recipe.timers) == 1
    assert length(recipe.sections) == 1
    assert length(hd(recipe.sections).content) > 0

    # Test metadata
    assert recipe.metadata["map"]["title"] == "Simple Pasta"
    assert recipe.metadata["map"]["servings"] == "2"
    assert recipe.metadata["map"]["tags"] == ["pasta", "easy", "quick"]

    # Test ingredient details
    pasta = Enum.find(recipe.ingredients, fn i -> i.name == "pasta" end)
    assert pasta != nil
    assert pasta.quantity.unit == "g"
    assert pasta.quantity.value["value"]["value"]["value"] == 250.0

    # Test cookware
    pot = Enum.find(recipe.cookware, fn c -> c.name == "pot" end)
    assert pot != nil

    # Check if the recipe has any timers
    assert length(recipe.timers) > 0

    # Convert back to map for API compatibility
    map = BorkBorkBork.Recipe.to_map(recipe)
    assert is_map(map)
    assert map["metadata"]["map"]["title"] == "Simple Pasta"
  end

  test "build recipe from structs" do
    # This test just demonstrates how to build a recipe using structs
    # without relying on the parser

    pasta = %Ingredient{
      name: "pasta",
      quantity: %Quantity{
        unit: "g",
        value: %{
          "type" => "fixed",
          "value" => %{
            "type" => "number",
            "value" => %{"type" => "regular", "value" => 250.0}
          }
        }
      }
    }

    oil = %Ingredient{
      name: "olive oil",
      quantity: %Quantity{
        unit: "tbsp",
        value: %{
          "type" => "fixed",
          "value" => %{
            "type" => "number",
            "value" => %{"type" => "regular", "value" => 2.0}
          }
        }
      }
    }

    pot = %Cookware{
      name: "pot"
    }

    timer = %Timer{
      name: nil,
      quantity: %Quantity{
        unit: "minutes",
        value: %{
          "type" => "fixed",
          "value" => %{
            "type" => "number",
            "value" => %{"type" => "regular", "value" => 8.0}
          }
        }
      }
    }

    step1 = %Step{
      type: "step",
      value: %{
        "items" => [
          %{"type" => "text", "value" => "Bring a "},
          %{"type" => "cookware", "index" => 0},
          %{"type" => "text", "value" => " of water to boil."}
        ],
        "number" => 1
      }
    }

    step2 = %Step{
      type: "step",
      value: %{
        "items" => [
          %{"type" => "text", "value" => "Add "},
          %{"type" => "ingredient", "index" => 0},
          %{"type" => "text", "value" => " to the water and cook for "},
          %{"type" => "timer", "index" => 0},
          %{"type" => "text", "value" => " until al dente."}
        ],
        "number" => 2
      }
    }

    section = %Section{
      name: nil,
      content: [step1, step2]
    }

    recipe = %Recipe{
      metadata: %{"map" => %{"title" => "Simple Pasta", "servings" => "2"}},
      ingredients: [pasta, oil],
      cookware: [pot],
      timers: [timer],
      sections: [section],
      data: [2]
    }

    # Test recipe structure
    assert length(recipe.ingredients) == 2
    assert length(recipe.cookware) == 1
    assert length(recipe.timers) == 1
    assert length(recipe.sections) == 1
    assert length(hd(recipe.sections).content) == 2

    # Test ingredient names directly from the structs
    assert Enum.map(recipe.ingredients, & &1.name) == ["pasta", "olive oil"]

    # Test conversion to a map
    map = Recipe.to_map(recipe)
    assert is_map(map)
    assert map["metadata"]["map"]["title"] == "Simple Pasta"
    assert length(map["ingredients"]) == 2
  end
end
