defmodule Jirasaur.SuccessHelper do
  
  def show_success(conn) do
    user = conn.assigns[:user]
    task = conn.assigns[:task]
    user_task = conn.assigns[:user_task]
    get_response_details = get_response_details(user: user, task: task, user_task: user_task)
    response_text = elem(get_response_details,0)
    status_code = elem(get_response_details,1)
    conn
    |> Plug.Conn.put_status(status_code)
    |> Phoenix.Controller.render(Jirasaur.Api.V1.ReportView,"success.v1.json", response_text: response_text)
    |> Plug.Conn.halt()
  end

  def get_response_details(assoc \\ []) do 
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
