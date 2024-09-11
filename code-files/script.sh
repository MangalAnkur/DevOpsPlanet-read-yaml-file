#!/bin/bash

YAML_FILE='temp.yaml'
KEY_FORMAT=$2
SET_GIT_ENV=$3
INPUT_KEYS=$4

# Create temporary yaml file
cp $1 $YAML_FILE

# Remove spaces from yaml file from leading and trailing
sed -i 's/^[[:space:]]*//;s/[[:space:]]*$//' $YAML_FILE

configure_key_values(){
  key=$1
  value=$(yq e ".${key}" "$YAML_FILE")

  # Check if the value is empty
  if [ -z "$value" ]; then
    return 0
  fi
  # Print the key and its corresponding value
  if [ "$KEY_FORMAT" == "uppercase" ]; then
    key=$(echo "$key" | tr '[:lower:]' '[:upper:]')
  elif [ "$KEY_FORMAT" == "lowercase" ]; then
    key=$(echo "$key" | tr '[:upper:]' '[:lower:]')
  fi

  # Store the key-value in a dynamically named variable
  declare "$key=$value"

  if [ "$SET_GIT_ENV" = true ]; then
    echo "$key=${!key}"  >> $GITHUB_ENV
  fi
  echo "$key=${!key}" >> $GITHUB_OUTPUT
}

if [ "$INPUT_KEYS" == "all" ]; then
  # Read all keys from the YAML file
  keys=$(yq e 'keys | .[]' "$YAML_FILE")
  for input in $keys; do
    configure_key_values $input
  done
else
  # Read comma seperated keys from the YAML file
  IFS=',' read -r -a INPUT_KEYS_ARRAY <<< "$INPUT_KEYS"
  for input in "${INPUT_KEYS_ARRAY[@]}"; do
    configure_key_values $input
  done
fi

#clean up 
rm -f $YAML_FILE