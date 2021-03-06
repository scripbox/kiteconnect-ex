defmodule KiteconnectEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :kite_connect_ex,
      version: "0.1.0",
      elixir: "~> 1.9.1",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/scripbox/kiteconnect-ex",
      homepage_url: "https://github.com/scripbox/kiteconnect-ex"
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
      {:httpoison, "~> 1.7"},
      {:jason, "~> 1.1"},
      {:bypass, "~> 1.0", only: :test}
    ]
  end

  defp description do
    "Elixir client for Kite Connect APIs"
  end

  defp package do
    [
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/scripbox/kiteconnect-ex"}
    ]
  end
end
