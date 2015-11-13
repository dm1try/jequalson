defmodule JequalSON.Mixfile do
  use Mix.Project

  def project do
    [app: :jequalson,
     version: "0.1.1",
     elixir: "~> 1.1",
     description: description,
     package: package,
     preferred_cli_env: [espec: :test],
     deps: deps]
  end

  def application do
    []
  end

  defp deps do
    [{:espec, "~> 0.8.5", only: :test},
     {:poison, "~> 1.5", only: :test}]
  end

  defp description do
    """
    Helpers for testing JSON responses.
    """
  end

  defp package do
    [files: ["lib", "mix.exs", "README*", "LICENSE*", "license*"],
     maintainers: ["Dmitry Dedov"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/dm1try/jequalson"}]
  end
end
