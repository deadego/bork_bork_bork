# CLAUDE.md - Development Guidelines for BorkBorkBork

## Build/Test Commands
- Run all tests: `mix test`
- Run specific test: `mix test test/path/to/test_file.exs:line_number`
- Run tests with coverage: `mix test --cover`
- Interactive shell: `iex -S mix`
- Format code: `mix format`
- Compile: `mix compile`
- Clean: `mix clean`

## Code Style Guidelines
- **Naming**: Use PascalCase for modules, snake_case for functions/variables
- **Modules**: Group related functions in modules with clear, descriptive names
- **Formatting**: Follow conventions set by `mix format` (see .formatter.exs)
- **Parser Combinator Style**: Import `NimbleParsec` and define composable parser functions with `defparsec/2` and `defcombinatorp/2`
- **Error Handling**: Use pattern matching with `{:ok, result}` and `{:error, reason}` tuples
- **Documentation**: Add `@doc` and `@moduledoc` comments for public functions/modules
- **Functions**: Keep functions small and focused on a single task
- **Testing**: Write tests for all parser combinators and transformation functions