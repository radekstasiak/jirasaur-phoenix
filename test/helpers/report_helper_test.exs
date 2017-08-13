defmodule Shtask.ReportHelperTest do
	use Shtask.ModelCase
	use Timex
	import Shtask.Fixtures
	alias Shtask.ReportHelper
	alias Shtask.UserTask

	test "current task is nil" do 
	 user = fixture(:user)
	 current_task = ReportHelper.get_current_user_task(user.id)
	 assert current_task == nil
	end

	test "current task returns latest task correctly" do
	 user = fixture(:user)
	 user2 = fixture(:user, user_id: "RS1", user_name: "Sanema")

	 task_type = fixture(:task_type)
	 task_status = fixture(:task_status, task_status_name: "in progress")
	 task_jira_1 = fixture(:task,task_name: "JIRA-997",task_type: task_type, task_status: task_status)
	 task_jira_2 = fixture(:task,task_name: "JIRA-998",task_type: task_type, task_status: task_status)
	 task_jira_3 = fixture(:task,task_name: "JIRA-999",task_type: task_type, task_status: task_status)

	 time_now = Timex.local
	 time_50mins_ago = Timex.shift(time_now, minutes: -50)
	 time_day_ago = Timex.shift(time_now, days: -1)
	 time_day_ago_and_30_mins = Timex.shift(time_now, days: -1, minutes: -30)

	 user_task_from_yesterday = fixture(:user_task, task: task_jira_1, user: user, started: time_day_ago_and_30_mins, finished: time_day_ago )
	 user_task_earlier_today = fixture(:user_task, task: task_jira_2, user: user, started: time_50mins_ago)
	 other_user_task_most_recent_task = user_task_earlier_today = fixture(:user_task, task: task_jira_3, user: user2, started: time_now)
	 most_recent = ReportHelper.get_current_user_task(user.id)
	 most_recent = UserTask.preload(most_recent.id)
	 most_recent_task_name = most_recent.task.name
	 most_recent_user_name = most_recent.user.user_name
	 assert most_recent_task_name == task_jira_2.name
	 assert most_recent_user_name == user.user_name
	end
end
