%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "test/"],
        excluded: [~r"/_build/", ~r"/deps/", ~r"/node_modules/", "lib/tables.ex"]
      },
      strict: true,
      checks: %{
        disabled: [
          # Disable moduledoc check - this is a library with public API documented
          {Credo.Check.Readability.ModuleDoc, []},
          # Allow numbers without underscores in auto-generated code
          {Credo.Check.Readability.LargeNumbers, []},
          # Disable complexity checks for existing code - these are refactoring suggestions
          {Credo.Check.Refactor.CyclomaticComplexity, []},
          {Credo.Check.Refactor.Nesting, []},
          # Allow alias expansion in tests
          {Credo.Check.Readability.AliasAs, []}
        ]
      }
    }
  ]
}
