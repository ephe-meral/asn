defmodule ASN.Parser do
  @doc "Returns a map with bitstring-ip-masks associated to AS-IDs"
  def parse_ip_to_as_file(text) do
    text
    |> String.splitter("\n", trim: true)
    |> Stream.flat_map(&parse_ip_to_as_line/1)
  end

  @doc "Returns a tuple with {ip-prefix-bitstring, as}"
  def parse_ip_to_as_line(line) do
    # ip - / - mask - whitespaces - as-id
    case Regex.run(~r[(\d+)\.(\d+)\.(\d+)\.(\d+)/(\d+)\s+(\d+)], line) do
      [_, ip1, ip2, ip3, ip4, mask, as] ->
        [{[ip1, ip2, ip3, ip4] |> ip_to_tuple |> trunc_ip(String.to_integer(mask)), as |> String.to_integer}]
      _ -> []
    end
  end

  @doc "Returns a map with AS-IDs associated to AS-Names"
  def parse_as_to_asn_file(text) do
    text
    |> String.splitter("\n", trim: true)
    |> Stream.flat_map(&parse_as_to_asn_line/1)
  end

  @doc "Returns a tuple with `{as, asn}`"
  def parse_as_to_asn_line(line) do
    # as - whitespaces - asn
    case Regex.run(~r/(\d+)\s+(.+)/, line) do
      [_, as, asn] -> [{as |> String.to_integer, asn |> String.strip}]
      _            -> []
    end
  end

  @doc "Parses an IP from a string, or takes a list of the bytes as integer values as string"
  def ip_to_tuple([_, _, _, _] = ip) do
    ip = Enum.map(ip, &String.to_integer/1)
    if Enum.all?(ip, fn x -> x in 0..255 end),
    do:   List.to_tuple(ip),
    else: nil
  end
  def ip_to_tuple(ip) when is_binary(ip) do
    case Regex.run(~r/(\d+)\.(\d+)\.(\d+)\.(\d+)/, ip) do
      [_, ip1, ip2, ip3, ip4] -> ip_to_tuple([ip1, ip2, ip3, ip4])
      _                       -> nil
    end
  end

  @doc "Returns a bitstring or nil"
  def trunc_ip({ip1, ip2, ip3, ip4}, mask) do
    <<final::bits-size(mask), _::bits>> = <<ip1::8, ip2::8, ip3::8, ip4::8>>
    final
  end
end

