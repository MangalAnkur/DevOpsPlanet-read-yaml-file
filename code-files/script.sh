#!/bin/bash

YAML_FILE='temp.yaml'
KEY_FORMAT=$2
SET_GIT_ENV=$3

# Create temporary yaml file
cp $1 $YAML_FILE

# Remove spaces from yaml file from leading and trailing
sed -i 's/^[[:space:]]*//;s/[[:space:]]*$//' $YAML_FILE

# Read all keys from the YAML file
keys=$(yq e 'keys | .[]' "$YAML_FILE")

# Loop through all keys and store values in variables
for key in $keys; do
  # Use yq to get the value for each key
  value=$(yq e ".${key}" "$YAML_FILE")

  # Check if the value is empty
  if [ -z "$value" ]; then
    continue
  fi
  # Print the key and its corresponding value
  if [ "$KEY_FORMAT" == "uppercase" ]; then
    key=$(echo "$key" | tr '[:lower:]' '[:upper:]')
  elif [ "$KEY_FORMAT" == "lowercase" ]; then
    key=$(echo "$key" | tr '[:upper:]' '[:lower:]')
  fi

  # Store the key-value in a dynamically named variable
  declare "$key=$value"

  if [ "$3" = true ]; then
    echo "$key=${!key}"  >> $GITHUB_ENV
  fi
  echo "$key=${!key}" >> $GITHUB_OUTPUT
done

#clean up 
rm -f $YAML_FILE