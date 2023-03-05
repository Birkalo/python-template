from setuptools import setup, find_packages

# To install the library, run the following
#
# python3 setup.py install
#
# prerequisite: setuptools
# http://pypi.python.org/pypi/setuptools

with open('VERSION') as f:
    version_number = f.read()

setup(
    name='PROJECT_NAME',
    version=version_number,
    description=('PROJECT DESCRIPTION'),
    author='Toby Birkett',
    author_email='python-template@toby.8shield.net',
    url='-',
    packages=find_packages(),
    scripts=['main_directory/main_module.py'],
    entry_points={
        'console_scripts': [
            'main_project = main_directory.main_module:main_method',
        ]
    },
)
