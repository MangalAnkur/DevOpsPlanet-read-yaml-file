# Configure key-values from yaml file in GitHub Environment variables and GitHub Output

To configure key values from a YAML file in a GitHub job, you can use a GitHub Action to read the YAML file and configure these key-value pairs as [environment variables](https://docs.github.com/en/actions/learn-github-actions/environment-variables) and [GitHub outputs](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/passing-information-between-jobs) in your GitHub workflow. For more information about GitHub Actions, see [Understanding GitHub Actions](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions) in the *GitHub Docs*.


When you set an environment variable in your GitHub environment, it becomes available to all subsequent steps in your GitHub job. To learn how to use the environment variables, refer to the [Environment variables](https://docs.github.com/en/actions/learn-github-actions/environment-variables) section in the *GitHub Docs*.

To view the environment variables created from your YAML file, enable debug logging. For details, refer to [Enabling debug logging](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging) in the *GitHub Docs*.


### Usage

To use the action, include a step in your workflow with the following syntax

```
- name: Step name
  uses: MangalAnkur/DevOpsPlanet-read-yaml-file@v1
  with:
    yaml-file: (Required)  | Absolute path of the YAML file with filename
    key-transformation: (Optional) uppercase|lowercase|none default: none
    set-env-vars: (Optional) true|false default: true
    keys: (Optional) default: all | key1,key2,key3,...
```

### Parameters

- `yaml-file` 

Pass a value that includes the YAML file path and filename, assign the full path string to the variable, ensuring it correctly points to the location of the YAML file.

- `keys`

(Optional - default all) Pass key name to set as GitHub outputs and GitHub environment variable. Use `,` in case of multiple keys.

- `key-transformation`

(Optional - default none) By default, the step creates each environment variable name and GitHub outputs exactly as specified. You can configure the step to convert keys to lowercase using `lowercase` or to uppercase using `uppercase`.

- `set-env-vars`

(Optional - default true) By default, the action configures key-value pairs as environment variables within a GitHub Actions workflow. If you do not want to set these environment variables, you can modify the configuration by passing the value `false`. This will prevent the action from creating environment variables.

### Output

- `data` 

The output variable reads from `$GITHUB_OUTPUT` in JSON format.

uses: `${{ steps.id.outputs.data}} `

### Examples

**Example 1:**  
The following example creates GitHub environment variables and sets GitHub outputs for the key-value pairs defined in a YAML file.

config.yaml 
```
region: us-east-1
service_name: Ec2
Instance_type: t2.medium
```

```
- name: Read key-value pairs from YAML file 
  uses: MangalAnkur/DevOpsPlanet-read-yaml-file@v1
  with:
    yaml-file: file_path/config.yaml
    key-transformation: uppercase
```

GitHub output variable created in JSON Format:  

```
{
  "REGION": "us-east-1",
  "SERVICE_NAME": "Ec2",
  "INSTANCE_TYPE": "t2.medium",
}
```

GitHub Environment variables created:  

```
REGION=us-east-1
SERVICE_NAME=Ec2
INSTANCE_TYPE=t2.medium
```

**Example 2:**  
The following example sets GitHub outputs for the key-value pairs defined in a YAML file.

config.yaml 
```
region: us-east-1
service_name: Ec2
Instance_type: 
  Instance_type_1: t2.medium
  Instance_type_2: t2.large
```

```
- name: Read key-value pairs from YAML file 
  uses: MangalAnkur/DevOpsPlanet-read-yaml-file@v1
  with:
    secret-ids: |
      yaml-file: file_path/config.yaml
      key-transformation: lowercase
      set-env-vars: false
```

GitHub output variable created in JSON Format:  

```
{
  "region": "us-east-1",
  "service_name": "Ec2",
  "instance_type_1": "t2.medium",
  "instance_type_2": "t2.large"
}
```

**Example 3:**  
The following example demonstrates how to set and read GitHub outputs for the key-value pairs defined in a YAML file.

config.yaml 
```
region: us-east-1
service_name: Ec2
Instance_type: t2.medium
```

```
- name: Read key-value pairs from YAML file 
  uses: MangalAnkur/DevOpsPlanet-read-yaml-file@v1
  id: read-yaml-file
  with:
    yaml-file: file_path/config.yaml
    key-transformation: uppercase

- name: Use values
  run: |
    echo key value data is '${{ steps.read-yaml-file.outputs.data }}'
    key_value_data='${{ steps.read-yaml-file.outputs.data }}'
    region=$(echo "$key_value_data" | jq -r '.REGION')
    service_name=$(echo "$key_value_data" | jq -r '.SERVICE_NAME')
    echo region is $region and service name is $service_name

```

Output:

```
key value data is {
  "REGION": "us-east-1",
  "SERVICE_NAME": "Ec2",
  "INSTANCE_TYPE": "t2.medium",
}
region is us-east-1 and service name is Ec2
```

GitHub output variable created in JSON format:  

```
{
  "REGION": "us-east-1",
  "SERVICE_NAME": "Ec2",
  "INSTANCE_TYPE": "t2.medium",
}
```

GitHub Environment variables created:  

```
REGION=us-east-1
SERVICE_NAME=Ec2
INSTANCE_TYPE=t2.medium
```

**Example 4:**  
The following example sets GitHub outputs and GitHub Environment variables for the keys specified by the user as input.

config.yaml 
```
region: us-east-1
service_name: Ec2
Instance_type: 
  Instance_type_1: t2.medium
  Instance_type_2: t2.large
```

```
- name: Read key-value pairs from YAML file 
  uses: MangalAnkur/DevOpsPlanet-read-yaml-file@v1
  with:
      yaml-file: file_path/config.yaml
      key-transformation: uppercase
      set-env-vars: true
      keys: service_name,Instance_type_2
```

GitHub output variable created in JSON format:  

```
{
  "SERVICE_NAME": "Ec2",
  "INSTANCE_TYPE_2": "t2.large"
}
```

GitHub Environmant variables created:  

```
SERVICE_NAME=Ec2
INSTANCE_TYPE_2=t2.large
```

## License

This library is licensed under the MIT-0 License. See the LICENSE file.