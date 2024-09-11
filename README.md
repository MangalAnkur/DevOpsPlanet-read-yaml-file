# Use key-values from yaml file in GitHub Environment variables and GitHub Output

To use key values from a YAML file in a GitHub job, you can use a GitHub Action to read the YAML file and set these key-value pairs [environment variables](https://docs.github.com/en/actions/learn-github-actions/environment-variables) and [GitHub outputs](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/passing-information-between-jobs) in your GitHub workflow. For more information about GitHub Actions, see [Understanding GitHub Actions](https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions) in the *GitHub Docs*.


When you set environment variable to your GitHub environment, it is available to all other steps in your GitHub job.To learn how to use the environment variables, refer to the [Environment variables](https://docs.github.com/en/actions/learn-github-actions/environment-variables) section in the *GitHub Docs*.

To see the environment variables created from your YAML file, enable debug logging. For details, refer to [Enabling debug logging](https://docs.github.com/en/actions/monitoring-and-troubleshooting-workflows/enabling-debug-logging) in the *GitHub Docs*.


### Usage

To use the action, add a step to your workflow using the syntax provided below.

```
- name: Step name
  uses: MangalAnkur/DevOpsPlanet-read-yaml-file@v1
  with:
    yaml-file: (Required)  | Absolute path of the YAML file with filename
    key-transformation: (Optional) uppercase|lowercase|none default: none
    set-env-vars: (Optional) true|false default: true
```

### Parameters

- `yaml-file` 

Pass a value that includes the YAML file path and filename, assign the full path string to the variable, ensuring it correctly points to the location of the YAML file

- `key-transformation`

(Optional - default none) By default, the step creates each environment variable name and GitHub Output exactly as specified. you can configure the step to use lowercase letters with `lowercase` or to use uppercase letters with `uppercase`.

- `set-env-vars`

(Optional - default true) By default, the action configures key-value pairs as environment variables within a GitHub Actions workflow. If you prefer not to set these environment variables, you can modify the configuration by passing the value `false`. This will prevent the action from creating environment variables.

### Examples

**Example 1**  
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
    yaml-file: ./file_path/config.yaml
    key-transformation: uppercase
```

GitHub output variables created:  

```
REGION=us-east-1
SERVICE_NAME=Ec2
INSTANCE_TYPE=t2.medium
```

Environment variables created:  

```
REGION=us-east-1
SERVICE_NAME=Ec2
INSTANCE_TYPE=t2.medium
```

**Example 2**  
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
      yaml-file: ./file_path/config.yaml
      key-transformation: lowercase
      set-env-vars: false
```

GitHub output variables created:  

```
region=us-east-1
service_name=Ec2
instance_type_1=t2.medium
instance_type_2=t2.large
```

**Example 3**  
The following example demonstrates how to set and read GitHub outputs for the key-value pairs defined in a YAML file

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
    yaml-file: ./file_path/config.yaml

- name: Use values
  run: |
    echo "region is ${{ steps.read-yaml-file.outputs.region }}"
    echo "service_name is ${{ steps.read-yaml-file.outputs.service_name }}"
    echo "Instance_type is ${{ steps.read-yaml-file.outputs.Instance_type }}"
```

output:

```
region is us-east-1
service_name is Ec2
Instance_type is t2.medium
```

GitHub output variables created:  

```
region=us-east-1
service_name=Ec2
Instance_type=t2.medium
```

Environment variables created:  

```
region=us-east-1
service_name=Ec2
Instance_type=t2.medium
```

## License

This library is licensed under the MIT-0 License. See the LICENSE file.