# Shtask [![Build Status](https://travis-ci.org/radekstasiak/shtask.svg?branch=develop)](https://travis-ci.org/radekstasiak/shtask) <a href="https://codecov.io/gh/radekstasiak/shtask"> <img src="https://codecov.io/gh/radekstasiak/shtask/branch/develop/graph/badge.svg" alt="Codecov" />
</a>

It's a timetracking app intended to work along with Slack slash commands

* Report start time and end time of each task including meetings & breaks
* Report it down throughout the day
* App automatically calculates time spent on work-related tasks (jira tasks, support tasks i.e. helping others, * meetings) and how much time was spent on private things (i.e. lunch, other activities)

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

# shtask-phoenix
