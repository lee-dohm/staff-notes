# Contributing

👍🎉 First off, thanks for taking the time to contribute! 🎉👍

Our [README](README.md) describes the project, its purpose, and is necessary reading for contributors.

This project adheres to a [code of conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

Contributions to this project are made under the [MIT License](LICENSE.md).

## Help wanted

Browse [open issues](https://github.com/lee-dohm/staff-notes/issues) to see current requests.

[Open an issue](https://github.com/lee-dohm/staff-notes/issues/new) to tell us about a bug. You may also open a pull request to propose specific changes, but it's always OK to start with an issue.

## Common Tasks

This project follows the [GitHub "scripts to rule them all" pattern](http://githubengineering.com/scripts-to-rule-them-all/). The contents of the `scripts` directory are scripts that cover all common tasks:

* `script/setup` &mdash; Performs first-time setup
* `script/update` &mdash; Performs periodic updating
* `script/test` &mdash; Runs automated tests
* `script/server` &mdash; Launches the web server
* `script/console` &mdash; Opens the development console
* `script/db-console` &mdash; Opens the database console for the development database
* `script/docs` &mdash; Generates developer documentation
    * `--open` Opens the documentation in the local web browser after generation
    * `--test` Generates the documentation including test modules and helpers

Other scripts that are available but not intended to be used directly by developers:

* `script/bootstrap` &mdash; Used to do a one-time install of all prerequisites for a development machine
* `script/cibuild` &mdash; Used to run automated tests in the CI environment

## Style guide

### Git commit messages

* Use the present tense ("Add feature" not "Added feature")
* Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
* Limit the first line to 72 characters or less
* Reference issues and pull requests liberally after the first line
* Consider starting the commit message with an applicable emoji:
    * 🎨 `:art:` when improving the format/structure of the code
    * 🐎 `:racehorse:` when improving performance
    * 🚱 `:non-potable_water:` when plugging memory leaks
    * 📝 `:memo:` when writing docs
    * 🐛 `:bug:` when fixing a bug
    * 🔥 `:fire:` when removing code or files
    * 💚 `:green_heart:` when fixing the CI build
    * ✅ `:white_check_mark:` when adding tests
    * 🔒 `:lock:` when dealing with security
    * ⬆️ `:arrow_up:` when upgrading dependencies
    * ⬇️ `:arrow_down:` when downgrading dependencies
    * 👕 `:shirt:` when removing linter warnings

### Documentation

* **DO** use fenced code blocks rather than indented blocks for examples

### Templates

Templates for this web application are written using [Slime](https://github.com/slime-lang/slime) and the [Phoenix Slime engine](https://github.com/slime-lang/phoenix_slime).

### Views

* **DO** name functions beginning with `render` if they render a child template -- example `StaffNotesWeb.UserView.render_user_orgs/1`
* **DO** name functions that write elements directly for what they inject -- example `StaffNotesWeb.UserView.staff_badge/2`

### Writing tests

#### Controller tests

* **DO** verify HTTP status
* **DO** verify redirects
* **DO** verify assigns
* **DO** verify session values
* **DO NOT** verify content

#### View tests

* **DO** verify the correct content is displayed given the expected assigns
* **DO** verify the output of helper functions

## Resources

- [Contributing to Open Source on GitHub](https://guides.github.com/activities/contributing-to-open-source/)
- [Using Pull Requests](https://help.github.com/articles/about-pull-requests/)
- [GitHub Help](https://help.github.com)
