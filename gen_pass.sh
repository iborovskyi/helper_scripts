#!/usr/bin/env bash

printHelp () {
    echo "Usage: $0 <-d|-p> -s <PASS_LENGTH> -c <PASS_COUNT>"
    echo '-h|--help - print help'
    echo '-d|--digit - include digits (optional)'
    echo '-p|--punctuation - include puctuation (optional)'
    echo '-s|--string-length - password length (default=8)'
    echo '-c|--count - password count'
    echo -e "\nEXAMPLE: $0 -d -p -s 16 -c 4"
}

if [ -z "$1" ] || [ -z "$(echo $1 | grep '-')" ]; then
  printHelp
  exit 1
fi

checkVal () {
  if [ -z "$2" ]; then
    echo "Invalid option: $1 requires an argument" 1>&2
    exit 1
  fi
}

checkNumVal () {
  if [ -z "$(echo $2 | grep -E "^[0-9]+$")" ]; then
          echo "$1: value should be a number! Got $2"
          exit 1
  fi
}

TR_SPACES='[:upper:][:lower:]'
GREP_SPACES='| grep -E "[[:upper:]]" | grep -E "[[:lower:]]"'
CHECK_LINE_BEGINNING='| grep -E "^([[:upper:]]|[[:lower:]])"'
PASSWORD_LENGTH=8
NUM_PASSWORDS=1


while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in
    -h|--help )
      printHelp
      exit 0
      ;;
    -s|--string-length )
      checkVal $1 $2
      checkNumVal $1 $2
      if [ $2 -lt 8 ]; then
              echo "$1: password length should be 8 or longer! Setting to 8"
              PASSWORD_LENGTH=8
      else
              PASSWORD_LENGTH="$2"
      fi
      shift 2     # shift past flag and value
      ;;
    -c|--count )
      checkVal $1 $2
      checkNumVal $1 $2
      if [ $2 -lt 1 ]; then
              echo "$1: count of generated passwords should be at least 1! Setting to 1"
              NUM_PASSWORDS=1
      else
              NUM_PASSWORDS="$2"
      fi
      shift 2     # shift past flag and value
      ;;
    -d|--digit )
      TR_SPACES=$TR_SPACES'[:digit:]'
      GREP_SPACES=$GREP_SPACES'| grep -E "[[:digit:]]"'
      shift 1     # shift
      ;;
    -p|--punctuation )
      TR_SPACES=$TR_SPACES'[:punct:]'
      GREP_SPACES=$GREP_SPACES'| grep -E "[[:punct:]]"'
      shift 1     # shift
      ;;
    * )
      echo "Invalid option: $1" 1>&2
      exit 1
      ;;
  esac
done

GEN_PASS_CMD='cat /dev/urandom | tr -dc '"$TR_SPACES"' | fold -w '"$PASSWORD_LENGTH"' '"$CHECK_LINE_BEGINNING"' '"$GREP_SPACES"' | head -n '"$NUM_PASSWORDS"''
eval $GEN_PASS_CMD
