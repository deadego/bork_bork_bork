# BorkBorkBork 👨‍🍳
An elixir parser implementation for the [cooklang](https://cooklang.org) specification

## Usage

```elixir
# Parse a cooklang recipe
recipe_text = """
---
servings: 2
---

Mix the @flour{2%cups} and @water{1%cup}.
Wait for ~{5%minutes}.
Place in #oven{} at 180C.
"""

{:ok, recipe} = BorkBorkBork.parse(recipe_text)

# Access recipe data
recipe["metadata"]["map"]["servings"] # "2"
length(recipe["ingredients"]) # 2
recipe["ingredients"] |> Enum.at(0) |> Map.get("name") # "flour"
recipe["cookware"] |> Enum.at(0) |> Map.get("name") # "oven"
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bork_bork_bork` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bork_bork_bork, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/bork_bork_bork>.