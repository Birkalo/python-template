# Make file for python-template service

# Suppress echoing output unless explicitly requested to.
ifeq ($(VERBOSE),)
  SILENT=@
endif

define install_py_package
	@echo "Installing package"
	$(SILENT)venv/bin/pip3 install -r requirements.txt > logs/pip_installation.log
	$(SILENT)venv/bin/pip3 install dist/project_name.tar.gz > logs/package_installation.log
endef

pyVersion=3.10

# This should be the first target so that "make" alone prints usage.
.DESC: help #: 'make' & 'make help' list the available subcommands and descriptions.
help:
	@awk 'BEGIN {FS = " ?#?: ";print "\n Usage: make \033[36m<command>\033[0m\n\nCommands:"} /^.DESC: ?[a-zA-Z_-]/ \
	 { printf "  \033[36m%-10s\033[0m %s\n", $$2, $$3 }' $(MAKEFILE_LIST)

.DESC: run #: Runs the main module without building the package
run: venv
	@echo "Running initialise_tables.py"
	$(SILENT)venv/bin/python3 main_directory/main_module.py

.DESC: unit-test #: Uses pytest to execute all tests in main_directory/test
unit-test: venv mysql-docker-container logs
	@echo "Running unit tests"
	$(SILENT)venv/bin/pip3 install -r test-requirements.txt
	$(SILENT)venv/bin/python3 -m pytest

.DESC: lint #: Lint python modules with flake8
lint: venv logs
	@echo "Running flake8 lint"
	$(SILENT)venv/bin/pip3 install flake8 > logs/flake8_installation.log
	$(SILENT)venv/bin/flake8 --ignore=E501 main_directory

.DESC: install #: Install the python package to your virtual environment
install: venv logs dist/project_name.tar.gz
	$(call install_py_package)

.DESC: all #: Builds package, installs it to virtual environment, and runs it alongside the sql container
all: venv logs dist/project_name.tar.gz mysql-docker-container
	$(call install_py_package)
	@echo "Running main configuration"
	@echo "--------------------------------"
	$(SILENT)venv/bin/main_project

mysql-docker-container: mysql-docker-image
	@echo "Building docker container"
	$(SILENT)docker run -d -p 3306:3306 --name mysql-container mysql-image
	$(SILENT)touch $@

mysql-docker-image:
	@echo "Building mysql docker image"
	$(SILENT)docker build . -t mysql-image
	$(SILENT)touch $@

.DESC: venv #: Creates a python virtualenv with the specified version
venv:
	@echo "Creating new virtualenv in ./venv"
	$(SILENT)python$(pyVersion) -m venv venv/
	$(SILENT)venv/bin/pip$(pyVersion) install wheel

.DESC: logs #: Creates Log output directory.
logs:
	$(SILENT)mkdir -p logs/

.DESC: build #: Build only the python package
build: dist/project_name.tar.gz

dist/project_name.tar.gz: venv logs
	@echo "Building python package"
	$(SILENT)rm -f dist/project_name*.tar.gz
	$(SILENT)venv/bin/python$(pyVersion) setup.py sdist > logs/python_build.log
	$(SILENT)cp dist/PROJECT_NAME*.tar.gz $@

.DESC: clean-logs #: Deletes log directory
clean-logs:
	@echo "Removing logs folder"
	$(SILENT)rm -rf logs/

.DESC: clean-venv #: Deletes virtual environment
clean-venv:
	@echo "Removing Virtualenv"
	$(SILENT)rm -rf venv/

.DESC: clean-build #: Removes python package
clean-build:
	@echo "Removing build distributions"
	$(SILENT)rm -rf build dist *.egg-info main_directory/__pycache__
	@echo "Removing pytest cache"
	$(SILENT)rm -rf .pytest_cache main_directory/test/__pycache__

.DESC: clean-docker #: Stops container, and deletes image
clean-docker:
	@echo "Killing mysql-container"
	$(SILENT)-docker kill mysql-container
	@echo "Removing mysql-container"
	$(SILENT)-docker rm mysql-container
	@echo "Deleting mysql-image"
	$(SILENT)-docker image rm mysql-image
	@echo "Remove docker dummy mark files"
	$(SILENT)-rm mysql-docker-image mysql-docker-container

.DESC: clean-all #: Performs all 'clean-*' operations
clean-all: clean-logs clean-venv clean-build clean-docker