defmodule Jirasaur.ReportControllerTest do
  use Jirasaur.ConnCase

  System.put_env("SLACK_TOKEN", "aaa")
  @params %{token: "aaa",team_domain: "XY1", team_id: "radev", user_id: "RS1", user_name: "Radek"}

  test "ok response", %{conn: conn} do
    conn = post conn, api_v1_report_path(conn, :process_request), @params
    assert json_response(conn, 200) 
  end

  test "controller downcase user id and returns ok response", %{conn: conn} do
    attrs = %{@params | user_id: "rs1"}
    conn = post conn, api_v1_report_path(conn, :process_request), attrs
    assert json_response(conn, 200) 

    conn = post conn, api_v1_report_path(conn, :process_request), @params
    assert json_response(conn, 200) 
  end


  test "bad request response", %{conn: conn} do
    attrs = Map.delete(@params, :user_id)
    conn = post conn, api_v1_report_path(conn, :process_request), attrs
    assert json_response(conn, 400) =~ "bad_request"
  end

  test "unauthorized response", %{conn: conn} do
    attrs = %{@params | token: "bbb"}
    conn = post conn, api_v1_report_path(conn, :process_request), attrs
    assert json_response(conn,401) =~ "unauthorized"
  end


end
