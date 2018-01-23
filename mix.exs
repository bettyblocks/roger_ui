defmodule RogerUi.Mixfile do
  use Mix.Project

  def project do
    [
      app: :roger_ui,
      version: "0.1.4",
      elixir: "~> 1.5",
      elixirc_paths: ["lib", "web"],
      package: package(),
      description: """
      Dashboard and monitoring tools for Roger job processing system
      """,
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def package do
    [
      files: ~w(lib test web priv) ++
             ~w(LICENSE mix.exs README.md),
      maintainers: ["Antonio Abella", "Paul Engel"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/Spadavecchia/roger_ui"},
    ]
  end


  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {RogerUi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:roger, "~> 1.3"},
      {:plug, "~> 1.4"},
      {:cowboy, "~> 1.0"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:credo, ">= 0.0.0", only: :dev},
    ]
  end
end
