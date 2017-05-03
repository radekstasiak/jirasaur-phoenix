# defmodule Jirasaur.TaskRelationsTest do
#   use Jirasaur.ModelCase
#   import Jirasaur.Fixtures
#   alias Jirasaur.Task

# 	@valid_attrs %{name: "JIRA-XXZ", task_type_id: 1, task_status_id: 1}



# 	test "task should have a user" do
# 		task = fixture(:task)
# 		task = Task.preload(task)
# 		length = Kernel.length(task.users)
# 		user = fixture(:user)
# 		users = %{"users_ids"=> [user.id]}
# 		#IO.puts("users #{users}")
# 		params = %{name: task.name, task_type_id: task.task_type_id, task_status_id: task.task_status_id,users_ids: [user.id]}

# 		changeset = Task.changeset(%Task{}, params)
# 		#IO.puts("#{changeset}")
# 		#changeset = Task.changeset(task,users: Map.new(fixture(:user)])
# 		#IO.puts("#{changeset.valid?}")
# 		case Repo.update(changeset) do
#       		{:ok, updated_task} ->
#       			task = updated_task
      		
#       	{:error, changeset} ->
#         	IO.puts("njee")
#     	end
#     	task = Task.preload(task)
#     	IO.puts("#{task}")
#     	length = Kernel.length(task.users)
# 		IO.puts("AAA #{task.task_status.name} + #{length}")
		
# 		#task.users = [fixture(:user)]
# 		#IO.puts("user #{task.users}")
# 		#length = Kernel.length(task.users)
# 		assert 0 == 1
# 	end
# end
