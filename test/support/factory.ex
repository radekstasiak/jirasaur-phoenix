defmodule Shtask.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Shtask.Repo

def user_factory do
	%Shtask.User{
		user_id: "XYZ1",
		user_name: "Mike",
		team_id: "123X",
		team_domain: "radev",
	}
end

def task_factory do
	%Shtask.Task{
		name: "JIRA-123",
		task_type: build(:task_type),
		task_status: build(:task_status),
	}
end

def task_status_factory do
	%Shtask.TaskStatus{
		name: "in progress",
	}

end

def task_type_factory do
	%Shtask.TaskType{
		name: "task",
	}
end
def user_task_factory do
	%Shtask.UserTask{
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
  	task_uzeev_856 = insert(:task, name: "uzeev-856", task_type: task_type, task_status: task_status)
  	
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
    
    #log "todays" tasks for another user 
    user = insert(:user, user_id: "mk2")

    {status, taskStart} = Timex.parse(Date.to_string(today)<>" 08:45","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(today)<>" 09:30","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_morning,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(today)<>" 09:30","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(today)<>" 09:40","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_standup,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(today)<>" 09:40","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(today)<>" 09:49","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_private,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(today)<>" 09:49","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(today)<>" 13:02","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_uzeev_856,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(today)<>" 13:02","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(today)<>" 16:15","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_uzeev_656,
           user: user)
end

def populate_task_across_a_sprint(user) do
	# same task on 3 different days
	# same task across two different users
	  task_status = insert(:task_status)
    task_type = insert(:task_type)
    task_type_support = insert(:task_type, name: "support")   
    task_type_meeting = insert(:task_type, name: "meeting")   
    task_type_private= insert(:task_type, name: "private")

    task_morning = insert(:task, name: "morning", task_type: task_type_support, task_status: task_status)
    task_support = insert(:task, name: "support", task_type: task_type_support, task_status: task_status)
    task_standup = insert(:task, name: "standup", task_type: task_type_meeting, task_status: task_status)
    task_private = insert(:task, name: "private", task_type: task_type_private, task_status: task_status)
    
    task_grene_963 = insert(:task, name: "grene-963", task_type: task_type, task_status: task_status)
    task_grene_310 = insert(:task, name: "grene-310", task_type: task_type, task_status: task_status)
    task_efasa_702 = insert(:task, name: "efasa-702", task_type: task_type, task_status: task_status)
    task_grene_363 = insert(:task, name: "grene-363", task_type: task_type, task_status: task_status)
    {status,day1} = Timex.parse("2016-06-19", "%Y-%m-%d", :strftime)
    {status,day2} = Timex.parse("2016-06-20", "%Y-%m-%d", :strftime)
    {status,day3} = Timex.parse("2016-06-21", "%Y-%m-%d", :strftime)    
    user2 = insert(:user, user_id: "mk1")
    # ###
    # ##
    # #
    # DAY 1 2016-06-19
    # USER &default
    # #########
    # 08:30:00 8:40:00 0:10:00 0.11  mail/inbox  support
    # 08:44:00 8:54:00 0:10:00 0.11  breakfast private
    # 08:54:00 9:05:00 0:11:00 0.12  macos support support
    # 09:05:00 09:10:00 0:05:00 0.06  cig private
    # 09:10:00 12:13:00 3:03:00 2.03  meetings  meetings
    # 12:13:00 14:49:00 2:36:00 1.73  grene-963 task
    # 14:49:00 15:21:00 0:32:00 0.36  support support
    # 15:21:00 16:20:00 0:59:00 0.66  grene-310 task

    {status, taskStart} = Timex.parse(Date.to_string(day1)<>" 08:30","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day1)<>" 08:44","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_support,
           user: user)

	  {status, taskStart} = Timex.parse(Date.to_string(day1)<>" 08:44","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day1)<>" 08:54","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_private,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(day1)<>" 08:54","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day1)<>" 09:05","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_support,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(day1)<>" 09:05","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day1)<>" 09:10","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_private,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(day1)<>" 09:10","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day1)<>" 12:13","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_standup,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(day1)<>" 12:13","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day1)<>" 14:49","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_grene_963,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(day1)<>" 14:49","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day1)<>" 15:21","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_support,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(day1)<>" 15:21","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day1)<>" 16:20","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_grene_310,
           user: user)

    # ###
    # ##
    # #
    # DAY 1 2016-06-19
    # USER MK2
    # ##########
    # 08:59:00  09:15:00  0:16:00 0.18  mail/slack  support
    # 09:15:00  09:27:00  0:12:00 0.13  grene-310 task
    # 09:27:00  10:58:00  0:05:00 0.06  efasa-702 task
    # 10:58:00  11:20:00  0:22:00 0.24  cig private
    # 11:20:00  13:20:00  2:00:00 1.33  efasa-702 task
    # 13:20:00  13:51:00  0:31:00 0.34  lunch private
    # 13:51:00  13:55:00  0:04:00 0.04  efasa-702 task
    # 13:55:00  15:27:00  1:03:00 0.70  grene-310 task

    {status, taskStart} = Timex.parse(Date.to_string(day1)<>" 08:59","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day1)<>" 09:15","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_support,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day1)<>" 09:15","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day1)<>" 09:27","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_grene_310,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day1)<>" 09:27","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day1)<>" 10:58","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_efasa_702,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day1)<>" 10:58","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day1)<>" 11:20","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_private,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day1)<>" 11:20","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day1)<>" 13:28","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_efasa_702,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day1)<>" 13:20","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day1)<>" 13:51","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_private,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day1)<>" 13:51","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day1)<>" 13:55","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_efasa_702,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day1)<>" 13:55","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day1)<>" 15:27","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_grene_310,
           user: user2)
    
    # ###
    # ##
    # #
    # DAY 2 2016-06-20
    # USER USER &default
    # ##########
    # 09:30:00  09:35:00 0:05:00 0.06  standup meeting
    # 09:35:00  10:05:00  0:27:00 0.30  breakfast private
    # 10:05:00  11:01:00  0:56:00 0.62  efasa-702 task
    # 11:01:00  11:11:00  0:10:00 0.11  private private
    # 11:11:00  12:09:00  0:58:00 0.64  grene-310 task
    # 12:09:00  12:54:00  0:44:00 0.49  lunch private
    # 12:54:00  13:30:00  0:35:00 0.39  grene-363 task
    # 13:30:00  15:00:00  1:30:00 1.00  grene-963 task

    {status, taskStart} = Timex.parse(Date.to_string(day2)<>" 09:30","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day2)<>" 09:35","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_standup,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(day2)<>" 09:35","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day2)<>" 10:05","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_private,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(day2)<>" 10:55","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day2)<>" 11:01","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_efasa_702,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(day2)<>" 11:01","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day2)<>" 11:11","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_private,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(day2)<>" 11:11","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day2)<>" 12:09","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_grene_310,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(day2)<>" 12:09","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day2)<>" 12:54","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_private,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(day2)<>" 12:54","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day2)<>" 13:30","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_grene_363,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(day2)<>" 13:30","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day2)<>" 15:00","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_grene_963,
           user: user)
    # ###
    # ##
    # #
    # DAY 2 2016-06-20
    # USER MK2
    # ##########
    # 09:04:00 09:30:00 0:24:00 0.27  mail/slack  support
    # 09:30:00 09:35:00 0:05:00 0.06  standup meeting
    # 09:35:00 10:45:00 1:10:00 0.78  grene-310 task
    # 10:45:00 11:40:00 0:55:00 0.61  grene-363 task
    # 11:40:00 12:22:00 0:42:00 0.47  lunch private
    # 12:25:00 16:00:00 3:35:00 xxxx  efasa-702 task

    {status, taskStart} = Timex.parse(Date.to_string(day2)<>" 09:04","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day2)<>" 09:30","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_support,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day2)<>" 09:30","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day2)<>" 09:35","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_standup,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day2)<>" 09:35","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day2)<>" 10:45","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_grene_310,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day2)<>" 10:45","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day2)<>" 11:40","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_grene_363,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day2)<>" 11:40","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day2)<>" 12:22","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_private,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day2)<>" 12:22","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day2)<>" 16:00","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_efasa_702,
           user: user2)

    # ###
    # ##
    # #
    # DAY 3 2016-06-21
    # USER &default
    # ##########
    # 09:00:00 09:07:00 0:07:00 0.08  mailslack support
    # 09:07:00 09:30:00 0:23:00 0.26  breakfast private
    # 09:30:00 09:37:00 0:07:00 0.08  standup meeting
    # 09:37:00 09:45:00 0:07:00 0.08  grene-310 task
    # 09:45:00 09:56:00 0:11:00 0.12  coffee  private
    # 09:56:00 13:50:00 3:50:00 2.56  grene-363 task
    # 13:50:00 14:50:00 0:40:00 0.44  lunch private
    # 14:50:00 16:00:00 1:30:00 1.00  grene-363 task

    
    {status, taskStart} = Timex.parse(Date.to_string(day3)<>" 09:00","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day3)<>" 09:07","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_support,
           user: user)
    

    {status, taskStart} = Timex.parse(Date.to_string(day3)<>" 09:07","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day3)<>" 09:30","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_private,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(day3)<>" 09:30","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day3)<>" 09:37","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_standup,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(day3)<>" 09:37","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day3)<>" 09:45","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_grene_310,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(day3)<>" 09:45","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day3)<>" 09:56","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_private,
           user: user)

    {status, taskStart} = Timex.parse(Date.to_string(day3)<>" 09:56","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day3)<>" 13:50","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_grene_363,
           user: user)  

    {status, taskStart} = Timex.parse(Date.to_string(day3)<>" 13:50","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day3)<>" 14:30","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_private,
           user: user)  

    {status, taskStart} = Timex.parse(Date.to_string(day3)<>" 14:50","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day3)<>" 16:00","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_grene_363,
           user: user)

    # ###
    # ##
    # #
    # DAY 3 2016-06-21
    # USER MK2
    # ##########
    # 09:00:00 09:10:00 0:10:00 0.11  mail/slack  support
    # 09:10:00 09:30:00 0:20:00 0.22  breakfast private
    # 09:30:00 09:34:00 0:04:00 0.04  standup meeting
    # 09:34:00 11:25:00 1:51:00 1.23  grene-363
    # 11:25:00 12:22:00 0:57:00 0.63  lunch private
    # 12:22:00 14:46:00 2:21:00 1.57  grene-363 task
    # 14:50:00 15:13:00 0:23:00 0.26  efasa-207 task
    # 15:13:00 16:30:00 1:17:00 0.86  grene-963 task

    {status, taskStart} = Timex.parse(Date.to_string(day3)<>" 09:00","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day3)<>" 09:10","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_support,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day3)<>" 09:10","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day3)<>" 09:30","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_private,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day3)<>" 09:30","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day3)<>" 09:34","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_standup,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day3)<>" 09:34","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day3)<>" 11:25","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_grene_363,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day3)<>" 11:25","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day3)<>" 12:22","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_private,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day3)<>" 12:22","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day3)<>" 14:46","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_grene_363,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day3)<>" 14:46","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day3)<>" 15:13","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_efasa_702,
           user: user2)

    {status, taskStart} = Timex.parse(Date.to_string(day3)<>" 15:13","%Y-%m-%d %H:%M", :strftime)
    {status, taskFinish} = Timex.parse(Date.to_string(day3)<>" 16:30","%Y-%m-%d %H:%M", :strftime)
    insert(:user_task,
           started: taskStart,
           finished: taskFinish,
           task: task_grene_963,
           user: user2)


end

end
