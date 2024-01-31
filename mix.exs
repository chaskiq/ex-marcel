defmodule ExMarcel.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_marcel,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  defp description() do
    "Find the mime type of files, examining file, filename and declared type"
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "ex_marcel",
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* *LICENSE),
      licenses: ["MIT", "Apache-2.0"],
      links: %{"GitHub" => "https://github.com/chaskiq/ex-marcel"}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
