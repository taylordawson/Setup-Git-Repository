# Setup-Git-Repository

This script is written in perl with a purpose of providing ease of setup for
new git repositories. All the user has to do is pass basic arguments to the
script and it will handle the rest of the setup. The goal is to provide fast
setup of git repositorys and consistent formatting amoung modules/scripts.

## Author
Taylor Dawson - dawsoncapital1@gmail.com

## Dependencies
Git must be installed/setup on the machine. This uses parameters that are setup
in the git config file.

Required Perl Modules:
```
- Moo
- MooX::Options
- version
- IO::File
```

## Install
```
cd Setup-Git-Repository/
perl Makefile.PL
make
make test
make install
```

## Example Usage
```
setup_git_repository --script run_script --name Create-New-Repository --extension pl --desc 'setup of new perl program'
```
**or**
```
setup_git_repository -s run_script -n Create-New-Repository -e pl -d 'setup of new perl program'
```
## File Structure
This script will auto create the following file structure for the above given
parameters:

### Perl:
```
Create-New-Repository/
├── Makefile.PL
├── lib
│   └── Create
│       └── New
│           ├── Repository
│           │   └── DataSource.pm
│           └── Repository.pm
├── scripts
│   └── run_script
└── t
```
###Python:
```
createnewrepository/
├── docs
├── scripts
│   └── run_script
├── setup.py
└── createnewrepository
    ├── __init__.py
    └── tests
        └── __init__.py
```

## Script Usage
```
USAGE: setup_git_repository [-h] [long options ...]

    -d --desc=String       Basic program description to be included in documentation
    -e --extension=String  File extension: Perl => pl, python => py
    -n --name=String       name of the repository seperated by dashes (Ex. New-Repository)
    -s --script=String     Optional: specify script name, if specified the scripts dir will be created
    --usage                show a short help message
    -h                     show a compact help message
    --help                 show a long help message
    --man                  show the manual
```
