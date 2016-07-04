defmodule ASN.MatcherTest do
  use ExUnit.Case, async: true

  test "ip to asn lookup" do
    assert ASN.Matcher.ip_to_asn("8.8.8.8") == {:ok, "Google Inc."}
    assert ASN.Matcher.ip_to_asn({8, 8, 8, 8}) == {:ok, "Google Inc."}
  end

  test "ip to as lookup" do
    assert ASN.Matcher.ip_to_as("8.8.8.8") == {:ok, 15169}
    assert ASN.Matcher.ip_to_as({8, 8, 8, 8}) == {:ok, 15169}
  end

  test "as to asn lookup" do
    # 36 bit mask
    assert ASN.Matcher.as_to_asn(15169) == {:ok, "Google Inc."}
  end
end
