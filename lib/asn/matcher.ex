defmodule ASN.Matcher do
  alias ASN.{Compiler, Table.IPtoAS, Table.AStoASN}

  @ip_to_as_source_file   Application.app_dir(:asn, "priv") <> "/ip_to_as.dump"
  @as_to_asn_source_file  Application.app_dir(:asn, "priv") <> "/as_to_asn.dump"
  @ip_to_as_lookup_table  Application.app_dir(:asn, "priv") <> "/ip_to_as_lookup_table.eterm"
  @as_to_asn_lookup_table Application.app_dir(:asn, "priv") <> "/as_to_asn_lookup_table.eterm"

  @external_resource @ip_to_as_source_file
  @external_resource @as_to_asn_source_file
  @external_resource @ip_to_as_lookup_table
  @external_resource @as_to_asn_lookup_table

  # Pre-compilation step

  Compiler.build_ip_to_as(@ip_to_as_source_file, @ip_to_as_lookup_table)
  Compiler.build_as_to_asn(@as_to_asn_source_file, @as_to_asn_lookup_table)

  # Runtime loaded stuff

  def start_link(opts \\ []) do
    Agent.start_link(fn ->
      {File.read!(@ip_to_as_lookup_table) |> :erlang.binary_to_term,
       File.read!(@as_to_asn_lookup_table) |> :erlang.binary_to_term}
    end, opts)
  end

  def ip_to_asn(agent, ip) when is_binary(ip),
  do: ASN.Parser.ip_to_tuple(ip) |> (&ip_to_asn(agent, &1)).()
  def ip_to_asn(agent, {_, _, _, _} = ip) do
    with {:ok, as}  <- ip_to_as(agent, ip),
         {:ok, asn} <- as_to_asn(agent, as),
         do: {:ok, asn}
  end
  def ip_to_asn(_, _), do: :error

  def ip_to_as(agent, ip) when is_binary(ip),
  do: ASN.Parser.ip_to_tuple(ip) |> (&ip_to_as(agent, &1)).()
  def ip_to_as(agent, {_, _, _, _} = ip),
  do: Agent.get(agent, fn {table, _} -> IPtoAS.lookup(table, ip) end)
  def ip_to_as(_), do: :error

  def as_to_asn(agent, as),
  do: Agent.get(agent, fn {_, table} -> AStoASN.lookup(table, as) end)
end
