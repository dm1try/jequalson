defmodule JequalSON.Mixfile do
  use Mix.Project

  def project do
    [app: :jequalson,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     preferred_cli_env: [espec: :test],
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:espec, "~> 0.8.5", only: :test},
     {:poison, "~> 1.5", only: :test}]
  end
end
