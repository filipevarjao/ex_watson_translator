defmodule ExWatsonTranslator.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_watson_translator,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Testing
      test_coverage: [
        tool: ExCoveralls
      ],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],

      # Dialyzer
      dialyzer: dialyzer()
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
      {:httpoison, "~> 1.3.0"},
      {:poison, "~> 4.0"},

      # Test
      {:excoveralls, "~> 0.9", only: :test},

      # Code Analisis
      {:dialyxir, "~> 1.0.0-rc.3", only: [:dev], runtime: false}
    ]
  end

  defp dialyzer do
    [
      ignore_warnings: "dialyzer.ignore-warnings"
    ]
  end
end
