defmodule Jirasaur.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Jirasaur.Repo

def user_factory do
	%Jirasaur.User{
		user_id: "XYZ1",
		user_name: "Mike",
		team_id: "123X",
		team_domain: "radev",
	}
end

def task_factory do
	%Jirasaur.Task{
		name: "JIRA-123",
		task_type: build(:task_type),
		task_status: build(:task_status),
	}
end

def task_status_factory do
	%Jirasaur.TaskStatus{
		name: "in progress",
	}

end

def task_type_factory do
	%Jirasaur.TaskType{
		name: "task",
	}
end
def user_task_factory do
	%Jirasaur.UserTask{
		started: Timex.now,
		finished: Timex.now,
		user: build(:user),
		task: build(:task),
	}
end

def populate_today(user) do
    task_status = insert(:task_status)
    task_type = insert(:task_type)
    task_type_support = insert(:task_type, name: "support")   
    task_type_meeting = insert(:task_type, name: "meeting")   
    task_type_private= insert(:task_type, name: "private")

    task_morning = insert(:task, name: "morning", task_type: task_type_support, task_status: task_status)
    task_support = insert(:task, name: "support", task_type: task_type_support, task_status: task_status)
    task_standup = insert(:task, name: "standup", task_type: task_type_meeting, task_status: task_status)
    task_private = insert(:task, name: "private", task_type: task_type_private, task_status: task_status)
    task_uzeev_656 = insert(:task, name: "uzeev-656", task_type: task_type, task_status: task_status)
    task_efase_487 = insert(:task, name: "efase-487", task_type: task_type, task_status: task_status)
  	
  	# "today" tasks
    today = Timex.today
    {status, taskStart} = Timex.parse(Date.to_string(today)<>" 09:00","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(today)<>" 09:30","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_support,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(today)<>" 09:30","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(today)<>" 09:40","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_standup,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(today)<>" 09:40","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(today)<>" 13:30","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_uzeev_656,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(today)<>" 13:30","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(today)<>" 14:01","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_private,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(today)<>" 14:01","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(today)<>" 15:00","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_efase_487,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(today)<>" 15:00","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(today)<>" 16:00","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_uzeev_656,
           user: user)
end

end