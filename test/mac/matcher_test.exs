defmodule ASN.MatcherTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, pid} = ASN.Matcher.start_link
    {:ok, matcher: pid}
  end

  test "ip to asn lookup", %{matcher: matcher} do
    assert ASN.Matcher.ip_to_asn(matcher, "8.8.8.8") == {:ok, "Google Inc."}
    assert ASN.Matcher.ip_to_asn(matcher, {8, 8, 8, 8}) == {:ok, "Google Inc."}
  end

  test "ip to as lookup", %{matcher: matcher} do
    assert ASN.Matcher.ip_to_as(matcher, "8.8.8.8") == {:ok, 15169}
    assert ASN.Matcher.ip_to_as(matcher, {8, 8, 8, 8}) == {:ok, 15169}
  end

  test "as to asn lookup", %{matcher: matcher} do
    # 36 bit mask
    assert ASN.Matcher.as_to_asn(matcher, 15169) == {:ok, "Google Inc."}
  end
end
