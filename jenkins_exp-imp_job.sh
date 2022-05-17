#!/usr/bin/env bash

export JENKINS_USER_ID=''                            # jenkins user id
export JENKINS_API_TOKEN=''                          # jenkins api token
JENKINS_URL='http://jenkins.example.com:8080'        # jenkins url (with port)
JENKINS_NAME="$(echo $JENKINS_URL | awk -F':' '{ print $2 }' | tr -dc "[a-z.]" | sed 's/\./_/g')"  # formatted jenkins name for internal use

if [ ! -f ~/bin/${JENKINS_NAME}-cli.jar ]; then
  wget "${JENKINS_URL}/jnlpJars/jenkins-cli.jar"
  mkdir -p ~/bin
  mv jenkins-cli.jar ~/bin/${JENKINS_NAME}-cli.jar
fi



case $1 in
        "get-job")
                if [ -z "$2" ]; then echo "USAGE: $0 get-job <JENKINS_JOB_NAME>"; exit 1; fi
                java -jar ~/bin/${JENKINS_NAME}-cli.jar -s "$JENKINS_URL" get-job $2 > ${2}.xml
                ;;
        "create-job")
                if [ ! -f "$2" ]; then echo "USAGE: $0 create-job <PATH_TO_XML> <JOB_NAME (optional)>"; exit 1; fi
                if [ -z "$(file $2 | grep -w XML)" ]; then echo "Not an XML: $2"; exit 1; fi
                if [ -z "$3" ]; then
                        job_name="$(echo $2 | awk -F'/' '{ print $NF }' | cut -d'.' -f1)"
                else
                        job_name="$3"
                fi
                java -jar ~/bin/${JENKINS_NAME}-cli.jar -s "$JENKINS_URL" create-job $job_name < $2
                ;;
        *)
                echo "USAGE:"
                echo "$0 get-job <JENKINS_JOB_NAME>"
                echo "$0 create-job <PATH_TO_XML> <JOB_NAME (optional)>"
                exit 1
                ;;
esac
