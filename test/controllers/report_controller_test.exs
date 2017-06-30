defmodule Jirasaur.ReportControllerTest do
  use Jirasaur.ConnCase
  import Jirasaur.Fixtures
  alias Jirasaur.Task
  alias Jirasaur.TaskType
  alias Jirasaur.UserTask

  System.put_env("SLACK_TOKEN", "aaa")
  @params %{token: "aaa",team_domain: "XY1", team_id: "radev", user_id: "RS1", user_name: "Radek",
            text: "morning"}

  test "ok response", %{conn: conn} do
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), @params
    assert json_response(conn, 200) 
  end

  test "controller downcase user id and returns ok response", %{conn: conn} do
    attrs = %{@params | user_id: "rs1"}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    assert json_response(conn, 200) 

    attrs = %{attrs | text: "JIRA-123"}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    assert json_response(conn, 200) 
  end


  test "bad request response", %{conn: conn} do
    attrs = Map.delete(@params, :user_id)
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    assert json_response(conn, 400) =~ "bad_request"
  end

  test "unauthorized response", %{conn: conn} do
    attrs = %{@params | token: "bbb"}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    assert json_response(conn,401) =~ "unauthorized"
  end

  test "request creates new task", %{conn: conn} do
    text = "JI2-123" 
    attrs = %{@params | text: text}
    tasks = Repo.all(Task)
    length_before_req = Kernel.length(tasks)
    
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
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
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    task = conn.assigns[:task]
    assert json_response(conn, 200)
    assert task.task_type.name == "support"
  end

  test "jira task is correctly recognized",  %{conn: conn} do
    text = "JIRA24-124" 
    attrs = %{@params | text: text}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    task = conn.assigns[:task]
    assert json_response(conn, 200)
    assert task.task_type.name == "task"
  end

  test "private task is correctly recognized",  %{conn: conn} do
    text = "private" 
    attrs = %{@params | text: text}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    task = conn.assigns[:task]
    assert json_response(conn, 200)
    assert task.task_type.name == "private"
  end

  test "meeting task is correctly recognized",  %{conn: conn} do
    text = "meeting" 
    attrs = %{@params | text: text}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
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
    
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
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
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
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
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    assert json_response(conn, 200)
    task = conn.assigns[:task]
    task = Task.preload(task.id)
    assert task.task_type.name == "support"
  end

  test "request with more than 3 params is redirected to error view", %{conn: conn} do
    text ="param1 param2 param3 param4"
    attrs = %{@params | text: text}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs    
    assert json_response(conn, 400) =~ "bad_request"
  end


  test "request morning as first request today" do
    text = "morning"
    attrs = %{@params | text: text}

    user_tasks = Repo.all(UserTask)
    length_before_req = Kernel.length(user_tasks)

    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    assert json_response(conn, 200)

    user_tasks = Repo.all(UserTask)
    length_after_req = Kernel.length(user_tasks)

    assert length_after_req == length_before_req + 1
    user_task = conn.assigns[:user_task]
    assert user_task != nil

    task = conn.assigns[:task]
    assert task.id == user_task.task_id
    user_task = UserTask.preload(user_task.id)
    assert user_task.task.name == text
  end

  test "request morning as not first request today" do
    user = fixture(:user, 
                   token: "aaa",
                   team_domain: "XY1",
                   team_id: "radev",
                   user_id: "RS1",
                   user_name: "Radek")
    user_task = fixture(:user_task, user: user)
    text = "morning"
    attrs = %{@params | text: text}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    user_task = conn.assigns[:user_task]
    assert user_task==nil
    assert json_response(conn, 400) =~ "already signed in"
  end

  test "request off as first request today" do
    text = "off"
    attrs = %{@params | text: text}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    user_task = conn.assigns[:user_task]
    assert user_task==nil
    assert json_response(conn, 400) =~ "you have no reports today"
  end

  test "request off as not first request today" do
    user = fixture(:user, 
                   token: "aaa",
                   team_domain: "XY1",
                   team_id: "radev",
                   user_id: "RS1",
                   user_name: "Radek")
    user_task = fixture(:user_task, user: user)

    text = "off"
    
    user_tasks = Repo.all(UserTask)
    length_before_req = Kernel.length(user_tasks)
    attrs = %{@params | text: text}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    user_tasks = Repo.all(UserTask)
    length_after_req = Kernel.length(user_tasks)

    user_task = conn.assigns[:user_task]

    assert length_before_req == length_after_req
    assert user_task == nil
    assert json_response(conn, 200)
    
  end

  test "request updates previous task" do
    task = fixture(:task)
    text = "JIRA-512"

    user = fixture(:user, 
                   token: "aaa",
                   team_domain: "XY1",
                   team_id: "radev",
                   user_id: "RS1",
                   user_name: "Radek")
    user_task = fixture(:user_task, task: task, user: user)
    assert user_task.finished == nil
    
    attrs = %{@params | text: text}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    user_task = Jirasaur.UserTask.preload(user_task.id)
    new_user_task = conn.assigns[:user_task]
    assert json_response(conn, 200)
    assert user_task.finished != ""

    assert Timex.format!(user_task.finished,"%FT%T%:z", :strftime) == Timex.format!(user_task.started,"%FT%T%:z", :strftime)
    assert user_task.finished != nil
  end

  test "request creates new user task" do
    task = fixture(:task)
    text = task.name
    
    user_tasks = Repo.all(UserTask)
    length_before_req = Kernel.length(user_tasks)

    attrs = %{@params | text: text}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    user_tasks = Repo.all(UserTask)
    length_after_req = Kernel.length(user_tasks)

    user_task = conn.assigns[:user_task]

    assert length_after_req == length_before_req + 1
    assert user_task != nil
    assert json_response(conn, 200)
  end

  test "request task with explicit start time" do
  time = "14:51"
  task = fixture(:task, task_name: "JIRA-531")
  text = task.name<> " #{time}"
  #text = task.name
  attrs = %{@params | text: text}

  conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
  user_task = conn.assigns[:user_task]
  assert user_task != nil
  assert json_response(conn, 200)

  [hour, minute] = String.split time, ":"
  hourInteger = Integer.parse(hour)
  minuteInteger = Integer.parse(minute)
  today = Timex.now
  dateTime = %DateTime{year: today.year, month: today.month, day: today.day, hour: elem(hourInteger,0), minute: elem(minuteInteger,0), second: 0, zone_abbr: "UTC", time_zone: "Europe/London", utc_offset: 0, std_offset: 0}

  assert user_task.started == dateTime
  #off only one date
  #make sure new task star = started
  #make sure current task finish = new.started
  end

  test "request task with explicit start and finish time" do
  #off only one date
  #make sure new task star = started, finish = finished
  #make sure current task finish = new.started

  end
   #also test to check if current task is updated correctly


end
