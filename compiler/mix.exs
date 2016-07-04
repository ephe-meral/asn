defmodule ASN.Compiler.Mixfile do
  use Mix.Project

  def project do
    [app: :asn_compiler,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod]
  end

  def application do
    [applications: [:logger]]
  end
end

