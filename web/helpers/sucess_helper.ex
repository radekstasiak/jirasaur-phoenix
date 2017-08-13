defmodule Shtask.SuccessHelper do
  
  def show_success(conn) do
    user = conn.assigns[:user]

    if(conn.params["text"] =~ "report" or conn.params["text"] == "" )do
      task_name_report = conn.assigns[:task_name_report]
      type_name_report = conn.assigns[:type_name_report]
      get_response_details = generate_report_details(user, task_name_report, type_name_report)
      response_text = elem(get_response_details,0)
      status_code = elem(get_response_details,1)
      header="Report"
    else
      task = conn.assigns[:task]
      user_task = conn.assigns[:user_task]
      get_response_details = get_task_saved_details(user: user, task: task, user_task: user_task)
      response_text = elem(get_response_details,0)
      status_code = elem(get_response_details,1)
      header = "Saved!"
    end

    conn
    |> Plug.Conn.put_status(status_code)
    |> Phoenix.Controller.render(Shtask.Api.V1.ReportView,"success.v1.json", response_text: response_text, header: header)
    |> Plug.Conn.halt()
  end

  def generate_report_details(user, task_name_report, type_name_report)do  
    response = Enum.reduce task_name_report, "", fn ({x, k}, acc) ->
      {status,durationTime} = Timex.Duration.to_time(k)
      if(x =~ "-") do
        x = String.upcase(x)  
      end
      acc <> "#{x} => #{durationTime}\n"
    end
    response = response <> "\n"
    response = Enum.reduce type_name_report, response, fn ({x, k}, acc) ->
      {status,durationTime} = Timex.Duration.to_time(k)
      acc <> "#{x} => #{durationTime}\n"
    end
    IO.puts("#{response}")
    {response,201}
  end


  def get_task_saved_details(assoc \\ []) do 
      user = assoc[:user]
      task = assoc[:task]
      user_task = assoc[:user_task]
    cond do
        user_task == nil ->
         response_text = {"user: #{user.user_name}\ntask: #{task.name}\ntask type: #{task.task_type.name}",200}
        user_task != nil ->
         timeStart = Time.to_string(DateTime.to_time(user_task.started))
         cond do
           user_task.finished == nil ->
            timeFinish = ""
            user_task.finished != nil ->
            timeFinish = Time.to_string(DateTime.to_time(user_task.finished))
         end
         response_text = {"user: #{user.user_name}\n"
                          <>
                          "task: #{task.name}\n"
                          <>
                          "task type: #{task.task_type.name}\n"
                          <>
                          "started: #{timeStart}\n"
                          <>
                          "finished: #{timeFinish}",201}
        
      end
  end


end
