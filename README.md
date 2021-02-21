----------------
# Python Project Template
This is a template repo for a creating a lightweight, deployable python microservice with testing and build config, all backed by a MySQL database.

This project makes use of [python virtual environments](https://docs.python.org/3/tutorial/venv.html) and Gitlab's [Docker In Docker](https://docs.gitlab.com/ee/ci/docker/using_docker_build.html) service to maintain consistency between local development and the CI environment.
By executing all of your tests, linting, building, and deployment via the make commands - you can ensure that the actions performed on your local machine are the same as those being run by the CI.

## Template Features
The project has the following components:
 - Python specific files:
   - Setup.py
   - Requirements 
   - Manifest
 - MySQL 8.0 Database
   - Initialisation script
   - Template schemas
   - Default admin account
 - Gitlab CI script with stages:
   - Lint
   - Unit Test
   - Build
 - Makefile for consistency between local & CI development
   - Build & Run docker containers
   - Run unit tests
   - Lint python code 
 - Documentation:
   - Readme
   - Version 
   - Changelog
  

### Prerequisites

 - Docker
 - Python 3.7
 - GNU Make


### Usage

## Getting started
You can clone this repo and use it as the basis of your new python project.
Once you have the code locally you can perform a Find & Replace on the term 'project_name' to rename the relevant variables.

Remember! You need to remove the `.git` directory to detach it from this repository, and initialise your own before you commit any changes to git.  

The makefile has a comprehensive set of commands to help you build & test your project:
```
$ make

 Usage: make <command>

Commands:
  help       'make' & 'make help' list the available subcommands and descriptions.
  run        Runs the main module without building the package
  unit-test  Uses pytest to execute all tests in main_directory/test
  lint       Lint python modules with flake8
  install    Install the python package to your virtual environment
  all        Builds package, installs it to virtual environment, and runs it alongside the sql container
  venv       Creates a python3.7 virtualenv
  logs       Creates Log output directory.
  build      Build only the python package
  clean-logs Deletes log directory
  clean-venv Deletes virtual environment
  clean-build Removes python package
  clean-docker Stops container, and deletes image
  clean-all  Performs all 'clean-*' operations
```

## Running the tests

Running `make unit-test` will execute the tests with the following steps:
   1. Checks if the following components exist, and builds them if they don't:
      1. Python virtual environment
      2. Mysql docker container
      3. Logs directory for output
   2. Installs the packages listed in `test-requirements.txt` with `pip3`
   3. Runs the tests using `pytest` 

### Linting

This project abides by pep8 standards, enforced by the pyflake linter. 
You can lint your project with `make lint`, which will return nothing when it succeeds.

```
$ make lint
Running flake8 lint
```
The linting is performed inside of the virtual environment, and currently excludes "line too long" errors (E501).

## Building
You can build this python project into a pip installable package with `make build`. You can also use `make all` to build,
install, and run the package in your virtual environment.

If you make any changes and need to rebuild, you must run `make clean` to remove the existing package (or delete it manually).

The build output is directed to `logs/python_build.log`

```
$ make clean-venv
Removing Virtualenv

$ make build
Creating new virtualenv in ./venv
Collecting wheel
  Using cached wheel-0.36.2-py2.py3-none-any.whl (35 kB)
Installing collected packages: wheel
Successfully installed wheel-0.36.2
Building python package

$ make build
make: Nothing to be done for 'build'.
```

The package is built in an identical fashion via gitlab-ci, so you can be assured of consistency. By default, the package is only built on the master branch.

## Built With

* [Makefile](https://www.gnu.org/software/make/manual/make.html) - Process management
* [Gitlab CI](https://docs.gitlab.com/ee/ci/) - The CI-CD process used
* [MySQL](https://dev.mysql.com/) - Database backing project

## License

This program is Free Software: You can use, study share and improve it at your
will. Specifically you can redistribute and/or modify it under the terms of the
[GNU General Public License](https://www.gnu.org/licenses/gpl.html) as
published by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://gitlab.com/templates.core/python-template/-/tags). 

## Authors

* **Toby Birkett** - [Birkalo](https://gitlab.com/Birkao)

## Acknowledgments
* Billie Thompson - Wrote the template readme - [PurpleBooth](https://github.com/PurpleBooth)
* Vikash Kothary - Gave helpful feedback on the makefile - [VikashKothary](https://gitlab.com/VikashKothary)