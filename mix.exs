defmodule ASN.Mixfile do
  use Mix.Project

  def project do
    [app: :asn,
     version: "0.1.0",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     description: "IP-to-AS-to-ASname lookup for Elixir.",
     package: package]
  end

  def application do
    [applications: [:logger]]
  end

  defp package do
    [maintainers: ["Johanna Appel"],
     licenses: ["WTFPL"],
     files: ["db", "compiler/lib", "compiler/mix.exs", "lib", "mix.exs", "README*", "LICENSE*"],
     links: %{"GitHub" => "https://github.com/ephe-meral/asn"}]
  end
end
