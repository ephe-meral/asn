defmodule ASN do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(ASN.Matcher, [[name: __MODULE__]])
    ]

    opts = [strategy: :one_for_one, name: ASN.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Returns the associated AS-Name of the given IP if any.
  """
  @spec ip_to_asn(String.t | :inet.ip4_address) :: {:ok, String.t} | :error
  def ip_to_asn(ip), do: ASN.Matcher.ip_to_asn(__MODULE__, ip)

  @doc """
  Returns the associated AS-ID of the given IP if any.
  """
  @spec ip_to_as(String.t | :inet.ip4_address) :: {:ok, integer} | :error
  def ip_to_as(ip), do: ASN.Matcher.ip_to_as(__MODULE__, ip)

  @doc """
  Returns the associated AS-Name of the given AS-ID if any.
  """
  @spec as_to_asn(integer) :: {:ok, String.t} | :error
  def as_to_asn(as), do: ASN.Matcher.as_to_asn(__MODULE__, as)
end
