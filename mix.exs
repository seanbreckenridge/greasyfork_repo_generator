defmodule GreasyforkRepoGenerator.MixProject do
  use Mix.Project

  def project do
    [
      app: :greasyfork_repo_generator,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      escript: [main_module: GreasyforkRepoGenerator.CLI],
      deps: deps()
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
      {:optimus, "~> 0.1.0"},
      {:poison, "~> 3.1"}
    ]
  end
end
