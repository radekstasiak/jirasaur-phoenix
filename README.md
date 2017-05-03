# Jirasaur

It's a timetracking app intended to work along with Slack slash commands

* Report start time and end time of each task including meetings & breaks
* Report it down throughout the day
* App automatically calculates data for scrum’s reports real effort
* Individual can effectively track how much time spent on work-related tasks (jira tasks, support tasks i.e. helping others, * meetings) and how much time was spent on private things (i.e. lunch, other activities)
* Offers 3rd person perspective on your efforts -  with raw data you know how “effective” is your everyday approach, no room to bs yourself
* With that knowledge and some self-discipline one can boost it’s individual performance and improve team results in meeting sprint’s goals


To start your Phoenix app:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Start Phoenix endpoint with `mix phoenix.server`
  * Add new slash command to your Slack team

## Usage
From you slack channel run </br>
```/commandname taskname tasktype(optional) timetaskstarted(optional)```

See wiki for a full example
## Learn more
  * Slack slash commands - https://api.slack.com/slash-commands
  * Heroku - https://www.heroku.com
  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## License
The app is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

# jirasaur-phoenix
