[![Build Status](https://travis-ci.org/ephe-meral/asn.svg?branch=master)](https://travis-ci.org/ephe-meral/asn)
[![Hex.pm](https://img.shields.io/hexpm/l/asn.svg "WTFPL Licensed")](https://github.com/ephe-meral/asn/blob/master/LICENSE)
[![Hex version](https://img.shields.io/hexpm/v/asn.svg "Hex version")](https://hex.pm/packages/asn)
[![Documentation](https://img.shields.io/badge/docs-hexpm-blue.svg)](http://hexdocs.pm/asn/)

# IP-to-AS-to-ASname lookup

Uses approximately the algorithm and resources described here: https://quaxio.com/bgp/

**We support only IPv4 at this point** (Until someone wants IPv6 and dares to update this :D)

## ASN databases

We use the APNIC files:

- IP-to-AS: http://thyme.apnic.net/current/data-raw-table
- AS-to-ASN: http://thyme.apnic.net/current/data-used-autnums

## setup

In your `mix.exs` file:

```elixir
def application do
  [applications: [:asn]] # simply add asn to your loaded applications
end

def deps do
  [{:asn, ">= 0.1.0"}]
end
```

Note that the initial compilation might take a few more seconds since it compiles the lookup table.

In case you **don't want the application single process solution**, you can also start `ASN.Matcher.start_link` processes by hand and use them through a similat API like the ASN module, just that you will need to pass the matcher process as the first value before the function args.

## usage

Due to the sheer size of the table, the compiler refuses to statically put it into the matcher module within a reasonable amount of time, and with a reasonable usage of memory. That's why we pre-compile the data into erlang-terms in external format and store that, and load it again on demand into a process.

**BEWARE** of wrongly formatted IP addresses! This accepts strings and tuples for IPs and integers for AS IDs, where IP-Strings need to be formatted like 'a.b.c.d' where a-d are integers between 0-255.

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
