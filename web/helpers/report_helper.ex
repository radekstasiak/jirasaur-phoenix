defmodule Jirasaur.ReportHelper do
	import Jirasaur.ErrorsHelper
	alias Jirasaur.Task
	alias Jirasaur.TaskStatus
	alias Jirasaur.TaskType

	@cmd
	@task_name

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
		task_name = String.downcase(assoc[:task_name])
		task_started = assoc[:started]
		task_finished = assoc[:finshed]
		if(task_name == nil) do
			show_bad_req(conn)
		end
		task = Jirasaur.Repo.get_by(Task, name: task_name)
		if (task == nil) do
		 task = get_task(conn,task_name)
		end
		task = Task.preload(task.id)
		conn = Plug.Conn.assign(conn, :task, task)
		send(conn)
	end

	defp get_task(conn,task_name) do
		task = Jirasaur.Repo.get_by(Task, name: task_name) ||
				insert_task(conn,task_name)
	end

	defp insert_task(conn, task_name) do
		task_type = get_task_type(conn,task_name)
		task_status = get_task_status(conn,task_name)
		changeset = Task.changeset(%Task{},%{name: task_name,
					task_type_id: task_type.id,
					task_status_id: task_status.id
					})
		case Jirasaur.Repo.insert(changeset) do
			{:ok, inserted_task} ->
				task=inserted_task
			{:error, _inserted_task_type} ->
				show_bad_req(conn)
		end


	end
	defp get_task_type(conn,task_name) do 
		task_type_name = cond do
			task_name == "private" ->
			 "private" 
			task_name == "lunch" ->
			 "private"
			Regex.match?((~r/[A-Za-z0-9].*[-][0-9].*/),task_name) ->
			  "task"
			true ->
			  "support"
		end
		task_type = Jirasaur.Repo.get_by(TaskType, name: task_type_name) || 
					insert_new_task_type(conn,task_type_name)
	end

	defp insert_new_task_type(conn,task_type_name) do
		changeset = TaskType.changeset(%TaskType{},%{name: task_type_name})
		case Jirasaur.Repo.insert(changeset) do
			{:ok, inserted_task_type} ->
				task_type=inserted_task_type
			{:error, _inserted_task_type} ->
				show_bad_req(conn)
		end

	end

	defp get_task_status(conn,task_name) do 
		task_status_name = "in progress"
		task_type = Jirasaur.Repo.get_by(TaskStatus, name: task_status_name) || 
					insert_new_task_status(conn,task_status_name)
	end

	defp insert_new_task_status(conn,task_status_name) do
		changeset = TaskStatus.changeset(%TaskStatus{},%{name: task_status_name})
		case Jirasaur.Repo.insert(changeset) do
			{:ok, inserted_task_status} ->
				task_status=inserted_task_status
			{:error, _inserted_task_type} ->
				show_bad_req(conn)
		end

	end





end