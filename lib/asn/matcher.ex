defmodule ASN.Matcher do
  alias ASN.Table.{IPtoAS, AStoASN}

  @ip_to_as_lookup_table (if File.exists?("db/ip_to_as_lookup_table.eterm") do
    File.read!("db/ip_to_as_lookup_table.eterm") |> :erlang.binary_to_term |> IPtoAS.new
  else
    %{}
  end)

  @as_to_asn_lookup_table (if File.exists?("db/as_to_asn_lookup_table.eterm") do
    File.read!("db/as_to_asn_lookup_table.eterm") |> :erlang.binary_to_term |> AStoASN.new
  else
    %{}
  end)

  def ip_to_asn(ip) when is_binary(ip), do: ASN.Parser.ip_to_tuple(ip) |> ip_to_asn
  def ip_to_asn({_, _, _, _} = ip) do
    with {:ok, as}  <- ip_to_as(ip),
         {:ok, asn} <- as_to_asn(as),
         do: {:ok, asn}
  end
  def ip_to_asn(_), do: :error

  def ip_to_as(ip) when is_binary(ip), do: ASN.Parser.ip_to_tuple(ip) |> ip_to_as
  def ip_to_as({_, _, _, _} = ip), do: IPtoAS.lookup(@ip_to_as_lookup_table, ip)
  def ip_to_as(_), do: :error

  def as_to_asn(as), do: AStoASN.lookup(@as_to_asn_lookup_table, as)

  @doc false
  def ip_to_as_lookup_table, do: @ip_to_as_lookup_table

  @doc false
  def as_to_asn_lookup_table, do: @as_to_asn_lookup_table
end
