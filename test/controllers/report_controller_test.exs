defmodule Jirasaur.ReportControllerTest do
  use Jirasaur.ConnCase

  test "request authenticated with correct SLACK TOKEN", %{conn: conn} do
  	System.put_env("SLACK_TOKEN", "aaa")
    conn = post conn, api_v1_report_path(conn, :process_request), token: "aaa"
    assert conn.status == 200
  end

    test "request unauthorized when incorrect SLACK TOKEN", %{conn: conn} do
  	System.put_env("SLACK_TOKEN", "aaa")
    conn = post conn, api_v1_report_path(conn, :process_request), token: "bbb"
    assert conn.status == 401
  end
end
