Code.require_file("parser.ex", "../lib/asn") # seen from the compiler dir
Code.require_file("table.ex", "../lib/asn")  # seen from the compiler dir

defmodule Mix.Tasks.Compile.Asn do
  use Mix.Task
  alias ASN.Table.{IPtoAS, AStoASN}
  @moduledoc "Compiles APNIC tables to the internally used lookup table format."
  @recursive true
  # Note that the ASN namespace is spelled 'Asn' here b/c Mix deduces the task name from it

  # Files are seen from the mac (main) dir
  @ip_to_as_source_file  "db/ip_to_as.dump"
  @as_to_asn_source_file "db/as_to_asn.dump"
  @ip_to_as_dest_file    "db/ip_to_as_lookup_table.eterm"
  @as_to_asn_dest_file   "db/as_to_asn_lookup_table.eterm"

  def run([ip_to_as_file, as_to_asn_file]) do
    case {build_ip_to_as(ip_to_as_file), build_as_to_asn(as_to_asn_file)} do
      {:noop, :noop} -> :noop
      _              -> :ok
    end
  end
  def run(_args), do: run([@ip_to_as_source_file, @as_to_asn_source_file])

  defp build_ip_to_as(ip_to_as_file) do
    if rebuild_needed?(ip_to_as_file, @ip_to_as_dest_file) do
      table = File.read!(ip_to_as_file) |> ASN.Parser.parse_ip_to_as_file |> IPtoAS.new
      File.write!(@ip_to_as_dest_file, table |> :erlang.term_to_binary)
      IO.puts("IP-to-AS-Table written with #{Enum.count(table.table)} entries")
      :ok
    else
      :noop
    end
  end

  defp build_as_to_asn(as_to_asn_file) do
    if rebuild_needed?(as_to_asn_file, @as_to_asn_dest_file) do
      table = File.read!(as_to_asn_file) |> ASN.Parser.parse_as_to_asn_file |> AStoASN.new
      File.write!(@as_to_asn_dest_file, table |> :erlang.term_to_binary)
      IO.puts("AS-to-ASN-Table written with #{Enum.count(table.table)} entries")
      :ok
    else
      :noop
    end
  end

  defp rebuild_needed?(source, dest) do
    if File.exists?(dest) do
      File.stat!(source).mtime >= File.stat!(dest).mtime
    else
      true
    end
  end
end
