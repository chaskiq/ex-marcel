defmodule ExMarcel.MixProject do
  use Mix.Project

  @version "0.2.0"
  @source_url "https://github.com/neilberkman/ex-marcel"

  def project do
    [
      app: :ex_marcel,
      name: "ExMarcel",
      version: @version,
      elixir: "~> 1.14",
      source_url: @source_url,
      homepage_url: @source_url,
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs(),
      test_coverage: [tool: ExCoveralls],
      start_permanent: Mix.env() == :prod
    ]
  end

  def cli do
    [
      preferred_envs: [coveralls: :test]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      # Dev/Test dependencies
      {:ex_doc, "~> 0.34", only: :dev, runtime: false},
      {:excoveralls, "~> 0.18", only: :test},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:quokka, "~> 2.11", only: :dev}
    ]
  end

  defp description do
    """
    MIME type detection library for Elixir - Modernized community fork of ex-marcel
    """
  end

  defp package do
    [
      files: ["lib", "data", "mix.exs", "README*", "LICENSE", "CHANGELOG.md"],
      maintainers: ["Neil Berkman"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "https://hexdocs.pm/ex_marcel/changelog.html",
        "GitHub" => @source_url
      }
    ]
  end

  defp docs do
    [
      extras: [
        "README.md",
        "CHANGELOG.md"
      ],
      main: "readme",
      source_ref: "v#{@version}",
      source_url: @source_url,
      groups_for_extras: [
        Changelog: ~r/CHANGELOG\.md/
      ]
    ]
  end
end
