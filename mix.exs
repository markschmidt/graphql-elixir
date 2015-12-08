defmodule GraphQL.Mixfile do
  use Mix.Project

  @version "0.0.7"

  @description "An Elixir implementation of Facebook's GraphQL core engine"
  @repo_url "https://github.com/joshprice/graphql-elixir"

  def project do
    [app: :graphql,
     version: @version,
     elixir: "~> 1.0",
     description: @description,
     package: package,
     source_url: @repo_url,
     homepage_url: @repo_url,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     name: "GraphQL",
     docs: [main: "extra-readme", extras: ["README.md"]]]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:mix_test_watch, "~> 0.2", only: :dev},

      # Doc dependencies
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.8", only: :dev},
      {:apex, "~> 0.3.4"},
      {:inch_ex, only: :dev}
    ]
  end

  defp package do
    [maintainers: ["Josh Price", "James Sadler"],
     licenses: ["BSD"],
     links: %{"GitHub" => @repo_url},
     files: ~w(lib src/*.xrl src/*.yrl mix.exs *.md LICENSE)]
  end
end
