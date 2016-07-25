defmodule ASN.Compiler do
  alias ASN.Table.{IPtoAS, AStoASN}
  @moduledoc "Compiles APNIC tables to the internally used lookup table format."

  def build_ip_to_as(ip_to_as_file, ip_to_as_dest_file) do
    if rebuild_needed?(ip_to_as_file, ip_to_as_dest_file) do
      table = File.read!(ip_to_as_file) |> ASN.Parser.parse_ip_to_as_file |> IPtoAS.new
      File.write!(ip_to_as_dest_file, table |> :erlang.term_to_binary)
      IO.puts("IP-to-AS-Table written with #{Enum.count(table.table)} entries")
      :ok
    else
      :noop
    end
  end

  def build_as_to_asn(as_to_asn_file, as_to_asn_dest_file) do
    if rebuild_needed?(as_to_asn_file, as_to_asn_dest_file) do
      table = File.read!(as_to_asn_file) |> ASN.Parser.parse_as_to_asn_file |> AStoASN.new
      File.write!(as_to_asn_dest_file, table |> :erlang.term_to_binary)
      IO.puts("AS-to-ASN-Table written with #{Enum.count(table.table)} entries")
      :ok
    else
      :noop
    end
  end

  defp rebuild_needed?(source, dest) do
    ensure_file(source)
    if File.exists?(dest) do
      File.stat!(source).mtime >= File.stat!(dest).mtime
    else
      true
    end
  end

  defp ensure_file(file) do
    if File.exists?(file), do: :ok,
    else: raise "File does not exist or cannot be found: #{file}"
  end
end
