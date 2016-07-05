defmodule ASN.Mixfile do
  use Mix.Project

  def project do
    [app: :asn,
     version: "0.1.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     compilers: [:asn | Mix.compilers],
     deps: deps,
     description: "IP-to-AS-to-ASname lookup for Elixir.",
     aliases: aliases,
     package: package]
  end

  def application do
    [mod: {ASN, []},
     applications: [:logger]]
  end

  defp deps do
    [{:asn_compiler, path: "compiler"}]
  end

  defp package do
    [maintainers: ["Johanna Appel"],
     licenses: ["WTFPL"],
     files: ["db", "compiler/lib", "compiler/mix.exs", "lib", "mix.exs", "README*", "LICENSE*"],
     links: %{"GitHub" => "https://github.com/ephe-meral/asn"}]
  end

  defp aliases do
    ["clean": ["cmd rm -f db/ip_to_as_lookup_table.eterm db/as_to_asn_lookup_table.eterm || true",
               "clean --deps"]]
  end
end
