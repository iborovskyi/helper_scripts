# About

Scripts, hacks, helpers I don't want to lose.

Migrated from https://pastebin.com/u/red_fisher

# tfswitch.sh

mimics some aspects of [tfswitch](https://tfswitch.warrensbox.com/)

Behavior:

- searches for file containing string 'required_version' in current folder
- downloads required_version from https://releases.hashicorp.com/terraform/
  to DOWNLOAD_PATH (/home/$(whoami)/bin/terraform_archive) if not present yet
- understands contraints '~>' and '>='
- unarchives to INSTALL_PATH (/home/$(whoami)/bin) and makes executable


# setup_vim.sh

installs vim, plugins and dependencies (every now and then new setup is required and I always forget list of plugins)


# gen_pass.sh

password generator (urandom 4ever!)

Usage:

    -h|--help - print help
    -d|--digit - include digits (optional)
    -p|--punctuation - include puctuation (optional)
    -s|--string-length - password length (default=8)
    -c|--count - password count

EXAMPLE: ./gen_pass.sh -d -p -s 16 -c 4

# jenkins_exp-imp_job.sh

export-import jenkins freestyle job

Usage:
```
get-job <JENKINS_JOB_NAME>                     - export frestyle job to current workdir;
create-job <PATH_TO_XML> <JOB_NAME (optional)> - import job xml;
                                                 by default JOB_NAME equals XML name without .xml
```

Configuration:
```
export JENKINS_USER_ID=''                            # jenkins user id
export JENKINS_API_TOKEN=''                          # jenkins api token
JENKINS_URL='http://jenkins.example.com:8080'        # jenkins url (with port)
```
