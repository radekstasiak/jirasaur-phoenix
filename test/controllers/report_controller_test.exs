defmodule Jirasaur.ReportControllerTest do
  use Jirasaur.ConnCase
  import Jirasaur.Task 
  alias Jirasaur.Task

  System.put_env("SLACK_TOKEN", "aaa")
  @params %{token: "aaa",team_domain: "XY1", team_id: "radev", user_id: "RS1", user_name: "Radek",
            text: "morning"}

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

  test "add new task", %{conn: conn} do
    text = "JI2-123" 
    attrs = %{@params | text: text}
    tasks = Repo.all(Task)
    length_before_req = Kernel.length(tasks)
    
    conn = post conn, api_v1_report_path(conn, :process_request), attrs
    tasks = Repo.all(Task)
    length_after_req = Kernel.length(tasks)
    
    task = conn.assigns[:task]
    assert length_after_req == length_before_req + 1
    assert task != nil
    assert task.name == String.downcase(text)
    assert json_response(conn, 200)
  end



end
