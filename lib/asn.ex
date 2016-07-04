defmodule ASN do
  @doc """
  Returns the associated AS-Name of the given IP if any.
  """
  @spec ip_to_asn(String.t | :inet.ip4_address) :: {:ok, String.t} | :error
  defdelegate ip_to_asn(ip), to: ASN.Matcher

  @doc """
  Returns the associated AS-ID of the given IP if any.
  """
  @spec ip_to_as(String.t | :inet.ip4_address) :: {:ok, integer} | :error
  defdelegate ip_to_as(ip), to: ASN.Matcher

  @doc """
  Returns the associated AS-Name of the given AS-ID if any.
  """
  @spec as_to_asn(integer) :: {:ok, String.t} | :error
  defdelegate as_to_asn(as), to: ASN.Matcher
end
