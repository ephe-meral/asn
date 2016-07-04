defmodule ASN.Table.IPtoAS do
  alias ASN.Table.IPtoAS

  defstruct [:min_bit_size, :max_bit_size, :table]

  def new, do: %IPtoAS{min_bit_size: 32, max_bit_size: 0, table: %{}}
  def new(mapping), do: mapping |> Enum.reduce(new, fn {key, value}, acc -> insert(acc, {key, value}) end)

  def insert(table, {key, value}) do
    %IPtoAS{
      min_bit_size: min(table.min_bit_size, bit_size(key)),
      max_bit_size: max(table.max_bit_size, bit_size(key)),
      table: table.table |> Map.put(key, value)}
  end

  def lookup(table, {_, _, _, _} = ip) do
    start_val = min(table.min_bit_size, table.max_bit_size)
    end_val   = max(table.min_bit_size, table.max_bit_size)
    # count down to get the most specific result
    (for size <- end_val..start_val, do: size)
    |> Enum.map(&ASN.Parser.trunc_ip(ip, &1))
    |> Enum.find_value(&Map.get(table.table, &1))
    |> case do
      nil -> :error
      x   -> {:ok, x}
    end
  end
end

defmodule ASN.Table.AStoASN do
  alias ASN.Table.AStoASN

  defstruct [:table]

  def new, do: %AStoASN{table: %{}}
  def new(mapping), do: mapping |> Enum.reduce(new, fn {key, value}, acc -> insert(acc, {key, value}) end)

  def insert(table, {key, value}) when is_binary(key), do: insert(table, {key |> String.to_integer, value})
  def insert(table, {key, value}) when is_integer(key), do: %AStoASN{table: table.table |> Map.put(key, value)}

  def lookup(table, key) when is_binary(key), do: lookup(table, key |> String.to_integer)
  def lookup(table, key) when is_integer(key), do: Map.fetch(table.table, key)
end
