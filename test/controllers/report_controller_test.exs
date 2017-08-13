defmodule Shtask.ReportControllerTest do
  use Shtask.ConnCase
  import Shtask.Fixtures
  import Shtask.Factory

  alias Shtask.Task
  alias Shtask.TaskType
  alias Shtask.UserTask

  System.put_env("SLACK_TOKEN", "aaa")
  @params %{token: "aaa",team_domain: "XY1", team_id: "radev", user_id: "RS1", user_name: "Radek",
            text: "morning"}

  test "ok response", %{conn: conn} do
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), @params
    assert json_response(conn, 201) 
  end

  test "controller downcase user id and returns ok response", %{conn: conn} do
    attrs = %{@params | user_id: "rs1"}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    assert json_response(conn, 201) 

    attrs = %{attrs | text: "JIRA-123"}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    assert json_response(conn, 201) 
  end


  test "bad request response", %{conn: conn} do
    attrs = Map.delete(@params, :user_id)
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    assert json_response(conn, 400) == %{
      "code"=>"bad_request"
    }
  end

  test "unauthorized response", %{conn: conn} do
    attrs = %{@params | token: "bbb"}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    assert json_response(conn,401) == %{
      "code" => "unauthorized"
    } 
  end

  test "task missing name", %{conn: conn} do
    text = nil  
    attrs = %{@params | text: text}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    assert json_response(conn, 400) == %{
      "code"=>"bad_request"
    }

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
    assert json_response(conn, 201)
  end

  test "support task is correctly recognized",  %{conn: conn} do
    text = "inbox/slack" 
    attrs = %{@params | text: text}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    task = conn.assigns[:task]
    assert json_response(conn, 201)
    assert task.task_type.name == "support"
  end

  test "jira task is correctly recognized",  %{conn: conn} do
    text = "JIRA24-124" 
    attrs = %{@params | text: text}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    task = conn.assigns[:task]
    assert json_response(conn, 201)
    assert task.task_type.name == "task"
  end

  test "private task is correctly recognized",  %{conn: conn} do
    text = "private" 
    attrs = %{@params | text: text}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    task = conn.assigns[:task]
    assert json_response(conn, 201)
    assert task.task_type.name == "private"
  end

  test "meeting task is correctly recognized",  %{conn: conn} do
    text = "meeting" 
    attrs = %{@params | text: text}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    task = conn.assigns[:task]
    assert json_response(conn, 201)
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
    assert json_response(conn, 201)
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
    assert json_response(conn, 201)
    assert length_after_req == length_before_req
    assert task.task_type.name == task_type_support.name

  end

  test "incorrect task name", %{conn: conn} do
    text = "JIRA2412a4" 
    attrs = %{@params | text: text}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    assert json_response(conn, 201)
    task = conn.assigns[:task]
    task = Task.preload(task.id)
    assert task.task_type.name == "support"
  end

  test "request with more than 3 params is redirected to error view", %{conn: conn} do
    text ="param1 param2 param3 param4"
    attrs = %{@params | text: text}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs    
    assert json_response(conn, 400)  == %{
      "code"=>"bad_request"
    }
  end


  test "request morning as first request today" do
    text = "morning"
    attrs = %{@params | text: text}

    user_tasks = Repo.all(UserTask)
    length_before_req = Kernel.length(user_tasks)

    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    assert json_response(conn, 201)

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
    assert json_response(conn, 400)  == %{
      "code"=>"already signed in"
    }
  end

  test "request off as first request today" do
    text = "off"
    attrs = %{@params | text: text}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    user_task = conn.assigns[:user_task]
    assert user_task==nil
    assert json_response(conn, 400) == %{
      "code"=>"you have no reports today"
    }

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
    user_task = Shtask.UserTask.preload(user_task.id)
    new_user_task = conn.assigns[:user_task]
    assert json_response(conn, 201)
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
    assert json_response(conn, 201)
  end

  test "request task with explicit start time" do
  time = "14:51"
  task = fixture(:task, task_name: "JIRA-531")
  text = task.name<> " #{time}"
  attrs = %{@params | text: text}

  conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
  user_task = conn.assigns[:user_task]
  assert user_task != nil
  assert json_response(conn, 201)

  [hour, minute] = String.split time, ":"
  hourInteger = Integer.parse(hour)
  minuteInteger = Integer.parse(minute)
  today = Timex.now
  dateTime = %DateTime{year: today.year, month: today.month, day: today.day, hour: elem(hourInteger,0), minute: elem(minuteInteger,0), second: 0, zone_abbr: "UTC", time_zone: "Europe/London", utc_offset: 0, std_offset: 0}

  assert user_task.started == dateTime

  end

  test "request task with explicit start and finish time" do
  timeStart = "14:51"
  timeEnd = "16:14"

  task = fixture(:task, task_name: "JIRA-534")
  text = task.name<> " #{timeStart}"<> " #{timeEnd}"
  
  attrs = %{@params | text: text}

  conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
  user_task = conn.assigns[:user_task]
  assert user_task != nil
  assert json_response(conn, 201)

  [hour, minute] = String.split timeStart, ":"
  hourInteger = Integer.parse(hour)
  minuteInteger = Integer.parse(minute)
  today = Timex.now
  dateStart = %DateTime{year: today.year, month: today.month, day: today.day, hour: elem(hourInteger,0), minute: elem(minuteInteger,0), second: 0, zone_abbr: "UTC", time_zone: "Europe/London", utc_offset: 0, std_offset: 0}

  assert user_task.started == dateStart

  [hour, minute] = String.split timeEnd, ":"
  hourInteger = Integer.parse(hour)
  minuteInteger = Integer.parse(minute)
  today = Timex.now
  dateFinish = %DateTime{year: today.year, month: today.month, day: today.day, hour: elem(hourInteger,0), minute: elem(minuteInteger,0), second: 0, zone_abbr: "UTC", time_zone: "Europe/London", utc_offset: 0, std_offset: 0}
  assert user_task.finished == dateFinish
  end

  test "request default report" do
    attrs = %{@params | text: ""}
    user = insert(:user, user_id: String.downcase(@params.user_id))
    populate_today(user)
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs

    task_name_report = conn.assigns[:task_name_report]
    type_name_report = conn.assigns[:type_name_report]
    task_name_report_length = map_size(task_name_report)
    type_name_report_length = map_size(type_name_report)
    assert task_name_report_length == 5
    assert type_name_report_length == 4
    assert json_response(conn, 201) == %{
      "attachments" => [%{
        "text" => "EFASE-487 => 00:59:00\n"
                <>"private => 00:31:00\n"
                <>"standup => 00:10:00\n"
                <>"support => 00:30:00\n"
                <>"UZEEV-656 => 04:50:00\n\n"
                <>"meeting => 00:10:00\n"
                <>"private => 00:31:00\n"
                <>"support => 00:30:00\n"
                <>"task => 05:49:00\n"
        }],
        "response_type" => "in_channel",
        "text" => "Report!"
      }
   end
  
  test "request report for particular task" do
    attrs = %{@params | text: "report GRENE-310"}
    user = insert(:user, user_id: String.downcase(@params.user_id))
    populate_task_across_a_sprint(user)
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    task_name_report = conn.assigns[:task_name_report]
    type_name_report = conn.assigns[:type_name_report]
    task_name_report_length = map_size(task_name_report)
    type_name_report_length = map_size(type_name_report)
    assert task_name_report_length == 1
    assert type_name_report_length == 1
    assert json_response(conn, 201) == %{
      "attachments" => [%{
        "text" =>"GRENE-310 => 02:05:00\n\n"                
                <>"task => 02:05:00\n"
        }],
        "response_type" => "in_channel",
        "text" => "Report!"
    }
  end

  test "request report for particular day" do
    attrs = %{@params | text: "report 2016-06-20"}
    user = insert(:user, user_id: String.downcase(@params.user_id))
    populate_task_across_a_sprint(user)
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    
    task_name_report = conn.assigns[:task_name_report]
    type_name_report = conn.assigns[:type_name_report]
    task_name_report_length = map_size(task_name_report)
    type_name_report_length = map_size(type_name_report)
    assert task_name_report_length == 6
    assert type_name_report_length == 3
    assert json_response(conn, 201) == %{
      "attachments" => [%{
        "text" => "EFASA-702 => 00:06:00\n"
                <>"GRENE-310 => 00:58:00\n"
                <>"GRENE-363 => 00:36:00\n"
                <>"GRENE-963 => 01:30:00\n"
                <>"private => 01:25:00\n"
                <>"standup => 00:05:00\n\n"
                <>"meeting => 00:05:00\n"
                <>"private => 01:25:00\n"
                <>"task => 03:10:00\n"
        }],
        "response_type" => "in_channel",
        "text" => "Report!"
      }


    attrs = %{@params | text: "report 2016-06-19"}
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs

    task_name_report = conn.assigns[:task_name_report]
    type_name_report = conn.assigns[:type_name_report]
    task_name_report_length = map_size(task_name_report)
    type_name_report_length = map_size(type_name_report)
    assert task_name_report_length == 5
    assert type_name_report_length == 4
    assert json_response(conn, 201) == %{
      "attachments" => [%{
        "text" => "GRENE-310 => 00:59:00\n"
                <>"GRENE-963 => 02:36:00\n"
                <>"private => 00:15:00\n"
                <>"standup => 03:03:00\n"
                <>"support => 00:57:00\n\n"
                <>"meeting => 03:03:00\n"
                <>"private => 00:15:00\n"
                <>"support => 00:57:00\n"
                <>"task => 03:35:00\n"
        }],
        "response_type" => "in_channel",
        "text" => "Report!"
      }


  end

  test "request report for particular day and task" do
    attrs = %{@params | text: "report GRENE-363 2016-06-21"}
    user = insert(:user, user_id: String.downcase(@params.user_id))
    populate_task_across_a_sprint(user)
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    
    task_name_report = conn.assigns[:task_name_report]
    type_name_report = conn.assigns[:type_name_report]
    task_name_report_length = map_size(task_name_report)
    type_name_report_length = map_size(type_name_report)
    assert task_name_report_length == 1
    assert type_name_report_length == 1
    assert json_response(conn, 201) == %{
      "attachments" => [%{
        "text" =>"GRENE-363 => 05:04:00\n\n"                
                <>"task => 05:04:00\n"
        }],
        "response_type" => "in_channel",
        "text" => "Report!"
      }
  end

  test "request report for correct day with incorrect date" do
    attrs = %{@params | text: "report JIRA-241 2017/06-21"}
    user = insert(:user, user_id: String.downcase(@params.user_id))
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    assert json_response(conn, 400) == %{
      "code"=>"bad_request"
    }
  end

  test "request report incorrect request" do
    attrs = %{@params | text: "report JIRA-241 JIRA-111 2017-06-21"}
    user = insert(:user, user_id: String.downcase(@params.user_id))
    conn = post build_conn(), api_v1_report_path(build_conn(), :process_request), attrs
    assert json_response(conn, 400) == %{
      "code"=>"bad_request"
    }
  end

end
