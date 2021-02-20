# Make file for python-template service

# Suppress echoing output unless explicitly requested to.
ifeq ($(VERBOSE),)
  SILENT=@
endif

# This should be the first target so that "make" alone prints usage.
help:
	@echo "Usage: 'make [all|clean|unit-test]'"

# Runs the main module without building the package
run: venv
	@echo "Running initialise_tables.py"
	$(SILENT)venv/bin/python3 main_directory/main_module.py

# Uses pytest to execute all tests in main_directory/test
unit-test: venv mysql-docker-container logs
	@echo "Running unit tests"
	$(SILENT)venv/bin/pip3 install -r test-requirements.txt
	$(SILENT)venv/bin/python3 -m pytest

lint: venv logs
	@echo "Running flake8 lint"
	$(SILENT)venv/bin/pip3 install flake8 > logs/flake8_installation.log
	$(SILENT)venv/bin/flake8 --ignore=E501 main_directory

# Builds package, installs it to virtual environment, and runs it
all: venv logs dist/project_name.tar.gz
	@echo "Installing package"
	$(SILENT)venv/bin/pip3 install -r requirements.txt > logs/pip_installation.log
	$(SILENT)venv/bin/pip3 install dist/project_name.tar.gz > logs/package_installation.log
	@echo "Running main configuration"
	@echo "--------------------------------"
	$(SILENT)venv/bin/main_project

mysql-docker-container: mysql-docker-image
	@echo "Installing package"
	$(SILENT)docker run -d -p 3306:3306 --name mysql-container mysql-image
	$(SILENT)touch $@

mysql-docker-image:
	@echo "Building mysql docker image"
	$(SILENT)docker build . -t mysql-image
	$(SILENT)touch $@

# Virtualenv directory
venv:
	@echo "Creating new virtualenv in ./venv"
	$(SILENT)python3.7 -m venv venv/
	$(SILENT)venv/bin/pip3.7 install wheel

# Log output directory.
logs:
	$(SILENT)mkdir -p logs/	

# Shortcut to only build package
build: dist/project_name.tar.gz

dist/project_name.tar.gz: venv logs
	@echo "Building python package"
	$(SILENT)rm -f dist/project_name*.tar.gz
	$(SILENT)venv/bin/python3.7 setup.py sdist > logs/python_build.log
	$(SILENT)cp dist/PROJECT_NAME*.tar.gz $@

clean:
	@echo "Removing Virtualenv"
	$(SILENT)rm -rf venv/
	@echo "Removing logs folder"
	$(SILENT)rm -rf logs/
	@echo "Removing build distributions"
	$(SILENT)rm -rf build dist *.egg-info main_directory/__pycache__
	@echo "Removing pytest cache"
	$(SILENT)rm -rf .pytest_cache main_directory/test/__pycache__
	@echo "Remove docker dummy mark files"
	$(SILENT)rm mysql-docker-image mysql-docker-container