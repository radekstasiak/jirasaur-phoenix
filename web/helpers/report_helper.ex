defmodule Jirasaur.ReportHelper do
	import Jirasaur.ErrorsHelper
	import Ecto.Query, only: [from: 2]
	use Timex
	alias Jirasaur.Task
	alias Jirasaur.TaskStatus
	alias Jirasaur.TaskType
	alias Jirasaur.UserTask
	alias Jirasaur.Repo
	
	def send(conn) do
		conn
	end

	def process_cmd(conn, _opts) do
		cmd = String.split(conn.params["text"])
		cmd_length = Kernel.length(cmd)


		cond do
			cmd_length == 1 ->
		 	 process_task(
		 	 	conn,
		 	 	task_name: Enum.at(cmd, 0)
		 	 	)
			cmd_length == 2 ->
			 process_task(
			 	conn,
			 	task_name: Enum.at(cmd, 0), 
			 	started: Enum.at(cmd,1)
			 	)
			cmd_length == 3 ->
			 	process_task(
			 	conn, 
			 	task_name: Enum.at(cmd, 0), 
			 	started: Enum.at(cmd,1),
			 	finished: Enum.at(cmd,2),
			 	)
			true ->
			 show_bad_req(conn)
		end
	end

	defp process_task(conn,assoc \\ []) do
		user = conn.assigns[:user]
		task_name = String.downcase(assoc[:task_name])
		if(assoc[:started] != nil) do
		   task_started = convertTimeToDateTime(assoc[:started])
		   current_task_finished = convertTimeToDateTime(assoc[:started])
		end

		if(task_started == nil) do
		  task_started = Timex.now
		  current_task_finished = Timex.now
		end
		if(assoc[:finished] != nil) do
		   task_finished = convertTimeToDateTime(assoc[:finished])
		end

		if(task_finished == nil) do
		  task_finished = ""
		end
		
		if(task_name == nil) do
			show_bad_req(conn)
		end
		task = get_task(conn,task_name)
		task = Task.preload(task.id)
		conn = Plug.Conn.assign(conn, :task, task)

		most_recent = get_current_user_task(user.id)
		cond do
			task.name == "off" and most_recent == nil  ->
				show_bad_req(conn, msg: "you have no reports today")
			task.name == "morning" and most_recent != nil ->
				show_bad_req(conn, msg: "already signed in")
			true ->
				if(most_recent != nil) do
					update_current_task(conn,most_recent, current_task_finished)	
				end

				if(task.name != "off") do 
					new_user_task = insert_user_task(conn, task.id, user.id, task_started, task_finished)
					conn = Plug.Conn.assign(conn, :user_task, new_user_task)
				end
				send(conn)
		end
	end

	defp convertTimeToDateTime(time) do
		[hour, minute] = String.split time, ":"
		hourInteger = Integer.parse(hour)
		minuteInteger = Integer.parse(minute)
		today = Timex.now
		dateTime = %DateTime{year: today.year, month: today.month, day: today.day, hour: elem(hourInteger,0), minute: elem(minuteInteger,0), second: 0, zone_abbr: "UTC", time_zone: "Europe/London", utc_offset: 0, std_offset: 0}

	end

	defp update_current_task(conn,user_task, finished) do
		params = %{task_id: user_task.task_id, 
				   user_id: user_task.user_id,
				   started: user_task.started,
				   finished: finished}
		changeset = UserTask.changeset(user_task, params)

  		case Repo.update(changeset) do
  		 {:ok, inserted_user_task} ->
			inserted_user_task	
    	 {:error, changeset} ->
      		show_bad_req(conn)
  end
		
	end

	defp insert_user_task(conn, task_id, user_id,started, finished) do
		changeset = UserTask.changeset(%UserTask{},%{task_id: task_id,
					user_id: user_id,
					started: started,
					finished: finished,
					})
		case Jirasaur.Repo.insert(changeset) do
			{:ok, inserted_task} ->
				inserted_task
			{:error, _inserted_task_type} ->
				show_bad_req(conn)
		end
	end


	def get_current_user_task(user_id) do
		date = Timex.now
		query = Ecto.Query.from(t in UserTask,
		 where: t.started >= ^Timex.beginning_of_day(date),
		 where: t.user_id == ^user_id,
  		 order_by: [desc: t.started],
  		 limit: 1)
		most_recent = Repo.one(query)
	end

	defp get_task(conn,task_name) do
		Jirasaur.Repo.get_by(Task, name: task_name) ||
				insert_task(conn,task_name)
	end

	defp insert_task(conn, task_name) do
		task_type_name = get_task_type(task_name)
		task_type = Jirasaur.Repo.get_by(TaskType, name: task_type_name) || 
					insert_new_task_type(conn,task_type_name)
		task_status = get_task_status(conn)
		changeset = Task.changeset(%Task{},%{name: task_name,
					task_type_id: task_type.id,
					task_status_id: task_status.id
					})
		case Jirasaur.Repo.insert(changeset) do
			{:ok, inserted_task} ->
				inserted_task
			{:error, _inserted_task_type} ->
				show_bad_req(conn)
		end
	end

	defp get_task_type(task_name) do 
		task_type_name = cond do
			task_name == "private" ->
			 "private" 
			task_name == "lunch" ->
			 "private"
			Regex.match?((~r/[A-Za-z0-9]*[-][0-9]*/),task_name) ->
			  "task"
			task_name == "meeting" ->
			  "meeting"
			 task_name == "standup" ->
			  "meeting"	
			true ->
			  "support"
		end
	end

	defp insert_new_task_type(conn,task_type_name) do
		changeset = TaskType.changeset(%TaskType{},%{name: task_type_name})
		case Jirasaur.Repo.insert(changeset) do
			{:ok, inserted_task_type} ->
				inserted_task_type
			{:error, _inserted_task_type} ->
				show_bad_req(conn)
		end

	end

	defp get_task_status(conn) do 
		task_status_name = "in progress"
		Jirasaur.Repo.get_by(TaskStatus, name: task_status_name) || 
					insert_new_task_status(conn,task_status_name)
	end

	defp insert_new_task_status(conn,task_status_name) do
		changeset = TaskStatus.changeset(%TaskStatus{},%{name: task_status_name})
		case Jirasaur.Repo.insert(changeset) do
			{:ok, inserted_task_status} ->
				inserted_task_status
			{:error, _inserted_task_type} ->
				show_bad_req(conn)
		end

	end





end