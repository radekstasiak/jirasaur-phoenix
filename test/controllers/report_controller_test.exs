defmodule Jirasaur.ReportControllerTest do
  use Jirasaur.ConnCase
  import Jirasaur.Fixtures
  alias Jirasaur.Task
  alias Jirasaur.TaskType

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

  test "request creates new task", %{conn: conn} do
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

  test "support task is correctly recognized",  %{conn: conn} do
    text = "inbox/slack" 
    attrs = %{@params | text: text}
    conn = post conn, api_v1_report_path(conn, :process_request), attrs
    task = conn.assigns[:task]
    assert json_response(conn, 200)
    assert task.task_type.name == "support"
  end

  test "jira task is correctly recognized",  %{conn: conn} do
    text = "JIRA24-124" 
    attrs = %{@params | text: text}
    conn = post conn, api_v1_report_path(conn, :process_request), attrs
    task = conn.assigns[:task]
    assert json_response(conn, 200)
    assert task.task_type.name == "task"
  end

  test "private task is correctly recognized",  %{conn: conn} do
    text = "private" 
    attrs = %{@params | text: text}
    conn = post conn, api_v1_report_path(conn, :process_request), attrs
    task = conn.assigns[:task]
    assert json_response(conn, 200)
    assert task.task_type.name == "private"
  end

  test "meeting task is correctly recognized",  %{conn: conn} do
    text = "meeting" 
    attrs = %{@params | text: text}
    conn = post conn, api_v1_report_path(conn, :process_request), attrs
    task = conn.assigns[:task]
    assert json_response(conn, 200)
    assert task.task_type.name == "meeting"
  end

  test "existing task is utilized when needed", %{conn: conn} do
    task =fixture(:task)
    text = task.name
    attrs = %{@params | text: text}
    tasks = Repo.all(Task)
    length_before_req = Kernel.length(tasks)
    
    conn = post conn, api_v1_report_path(conn, :process_request), attrs
    tasks = Repo.all(Task)
    length_after_req = Kernel.length(tasks)
    assert length_after_req == length_before_req
    assert json_response(conn, 200)
  end

  test "existing task type is utilized when needed", %{conn: conn} do
    text = "support" 
    task_type_support = fixture(:task_type, task_type_name: text)
    attrs = %{@params | text: text}

    task_types=Repo.all(TaskType)
    length_before_req = Kernel.length(task_types)
    conn = post conn, api_v1_report_path(conn, :process_request), attrs
    task_types=Repo.all(TaskType)
    task = conn.assigns[:task]
    length_after_req = Kernel.length(task_types)
    assert json_response(conn, 200)
    assert length_after_req == length_before_req
    assert task.task_type.name == task_type_support.name

  end

  test "incorrect task name", %{conn: conn} do
    text = "JIRA2412a4" 
    attrs = %{@params | text: text}
    conn = post conn, api_v1_report_path(conn, :process_request), attrs
    assert json_response(conn, 200)
    task = conn.assigns[:task]
    task = Task.preload(task.id)
    assert task.task_type.name == "support"
  end

  test "request with more than 3 params is redirected to error view", %{conn: conn} do
    text ="param1 param2 param3 param4"
    attrs = %{@params | text: text}
    conn = post conn, api_v1_report_path(conn, :process_request), attrs    
    assert json_response(conn, 400) =~ "bad_request"
  end


  test "request morning as first request today" do

  end

  test "request morning as not first request today" do
    
  end

  test "request off as first request today" do
    
  end

  test "request off as not first request today" do
    
  end

  test "new task pauses current task" do
    
  end

  test "request creates new user task" do
    
  end



end
