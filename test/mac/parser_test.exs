defmodule ASN.ParserTest do
  use ExUnit.Case, async: true
  import ASN.Parser

  @bin <<1::8, 2::8, 3::8>>

  test "ip parse" do
    assert ip_to_tuple("1.2.3.4") == {1, 2, 3 ,4}
    assert ip_to_tuple("1.2.3.256") == nil
  end

  test "ip to as line" do
    assert parse_ip_to_as_line("1.2.3.4/24 12345") == [{@bin, 12345}]
  end

  test "as to asn line" do
    assert parse_as_to_asn_line("12345 Some Company Inc.") == [{12345, "Some Company Inc."}]
  end
end
