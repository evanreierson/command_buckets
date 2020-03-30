defmodule CommandBuckets.MixProject do
  use Mix.Project

  def project do
    [
      app: :command_buckets,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      # This lets mix know the entrypoint for our application
      mod: {CommandBuckets.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # CQRS meat and potatoes
      {:commanded, "~> 1.0.0"},
      # Lets us interact with the EventStore storage that uses Postgres in the background
      {:commanded_eventstore_adapter, "~> 1.0"},
      # Used for json serialization
      {:jason, "~> 1.1"}
    ]
  end
end
