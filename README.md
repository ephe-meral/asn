[![Build Status](https://travis-ci.org/ephe-meral/asn.svg?branch=master)](https://travis-ci.org/ephe-meral/asn)
[![Hex.pm](https://img.shields.io/hexpm/l/asn.svg "WTFPL Licensed")](https://github.com/ephe-meral/asn/blob/master/LICENSE)
[![Hex version](https://img.shields.io/hexpm/v/asn.svg "Hex version")](https://hex.pm/packages/asn)

# IP-to-AS-to-ASname lookup

Uses approximately the algorithm and resources described here: https://quaxio.com/bgp/

**We support only IPv4 at this point** (Until someone wants IPv6 and dares to update this :D)

## ASN databases

Uses the APNIC files:

- IP-to-AS: http://thyme.apnic.net/current/data-raw-table
- AS-to-ASN: http://thyme.apnic.net/current/data-used-autnums

Uses the compiled version from the wireshark project:

## setup

In your `mix.exs` file:

```elixir
def deps do
  [{:asn, ">= 0.0.1"}]
end
```

Note that the initial compilation might take a few more seconds since it compiles the lookup table.

## usage

**BEWARE** of wrongly formatted IP addresses or AS'es! This accepts strings and tuples for IPs and integers for AS IDs, where IP-Strings need to be formatted like 'a.b.c.d' where a-d are integers between 0-255.

```elixir
# standard usage:
ASN.ip_to_asn("8.8.8.8")
# => {:ok, "Google Inc."}
ASN.ip_to_asn({8, 8, 8, 8})
# => {:ok, "Google Inc."}

ASN.ip_to_as("8.8.8.8")
# => {:ok, 15169}
ASN.ip_to_as({8, 8, 8, 8})
# => {:ok, 15169}

ASN.as_to_asn(15169)
# => {:ok, "Google Inc."}
```

## is it any good?

bien sûr.
