defmodule Covid.MixProject do
  use Mix.Project

  def project do
    [
      app: :covid,
      version: "0.1.0",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      releases: releases(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Covid.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  def releases() do
    [
      covid: [
        include_executables_for: [:unix],
        applications: [runtime_tools: :permanent]
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      # phoenix
      {:phoenix, "~> 1.4"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:plug_cowboy, "~> 2.0"},

      # apis
      {:certifi, "~> 2.4"},
      {:castore, "~> 0.1"},
      {:ssl_verify_fun, "~> 1.1"},
      {:tesla, "~> 1.3"},
      {:hackney, "~> 1.15.2"},
      {:jason, "~> 1.0"},

      # mailing
      {:bamboo, "~> 1.4"},

      # csv
      {:nimble_csv, "~> 0.6"},

      # phoenix helpers
      {:phoenix_html_simplified_helpers, "~> 2.1"},
      {:gettext, "~> 0.11"},

      # liveview
      {:phoenix_live_view, "~> 0.8.0"},
      {:phoenix_live_react, "~> 0.2"},

      # math
      {:statistics, "~> 0.6.2"},
      {:learn_kit, "~> 0.1.6"},

      # release
      {:libcluster, "~> 3.1"}
    ]
  end

  defp aliases do
    []
  end
end
