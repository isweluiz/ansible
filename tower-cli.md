# Some tips for ansible-tower-cli 

Before start, check the official documentation it should be your first guide before any "how to". 

- [Official Documentation](https://docs.ansible.com/ansible-tower/). 
- [Tower-cli Official Documentation](https://tower-cli.readthedocs.io/en/latest/cli_ref/usage/ROLE_MANAGEMENT.html)
- [Tower API Guide](https://docs.ansible.com/ansible-tower/latest/html/towerapi/api_ref.html#/Authentication/Authentication_o_list)

-----
Topics: 
- Install ansible-tower-cli
- Configure cli
- List user,teams,orgatnizations and team
- Create user,team,organization
- Get jobs 
- List templates
- Launch a job 
- List of all commands

## Ansible tower cli install

To install ansible-tower-cli is esier, you need to use the pip package. 

```bash
$ pip-2 install ansible-tower-cli

$ tower-cli  --version
Tower CLI 3.3.9
```

## Configuring ansible tower cli 

First you can check the current configurations. To do this, just follow the example bellow: 

```
$ tower-cli  config

# User options (set with `tower-cli config`; stored in ~/.tower_cli.cfg).
host: http://192.168.99.110/
username: admin
password: admin
verify_ssl: False

# Defaults.
use_token: False
verbose: False
certificate: 
format: human
color: True
insecure: False
description_on: False
oauth_token: 

```

To define the configuration, like host, user and password you can use the file  ```~/.tower_cli.cfg``` or comand like like bellow: 

```bash
tower-cli  config host http://192.168.99.110/
tower-cli  config username admin
tower-cli  config password admin
tower-cli  config verify_ssl false 
```

## Get information from system via CLI 

To get information from some AWX-TOWER you can use ```tower-cli [user,team,organization] list```:

```bash
tower-cli user list
== ======== ================= ========== ========= ============ ================= 
id username       email       first_name last_name is_superuser is_system_auditor 
== ======== ================= ========== ========= ============ ================= 
 1 admin    admin@example.com                              true             false
 2 linux    linux@hotmail.com linux      system           false             false
== ======== ================= ========== ========= ============ ================= 

tower-cli team list
== ==== ============ 
id name organization 
== ==== ============ 
 1 SRE             2

tower-cli organization list
== ======= 
id  name   
== ======= 
 2 3TB
 1 Default
== ======= 
```

If you need to get help to use a command, use the ``` tower-cli [command] --help``` to list the command options: 

```bash
tower-cli user --help
Usage: tower-cli user [OPTIONS] COMMAND [ARGS]...

  Manage users within Ansible Tower.

Options:
  --help  Show this message and exit.

Commands:
  copy    Copy a user.
  create  Create a user.
  delete  Remove the given user.
  get     Return one and exactly one user.
  list    Return a list of users.
  modify  Modify an already existing user.
```

## Creating user , team and organization 

How to create a user? Explore the manual tool to check "how to do"  ```tower-cli user create --help```. Ok, let's check what options we have to create a user via CLI:

NOTE: When you see the WORD [REQUIRED], this meand that the option is obligator 

```bash
$ tower-cli user create --help

Usage: tower-cli user create [OPTIONS]

  Create a user.

  Fields in the resource's --identity tuple are used for a lookup; if a
  match is found, then no-op (unless --force-on-exists is set) but do not
  fail (unless --fail-on-found is set).

Field Options:
  --username TEXT              [REQUIRED] The username field.
  --password TEXT              The password field.
  --email TEXT                 [REQUIRED] The email field.
  --first-name TEXT            The first_name field.
  --last-name TEXT             The last_name field.
  --is-superuser BOOLEAN       The is_superuser field.
  --is-system-auditor BOOLEAN  The is_system_auditor field.

Local Options:
  --fail-on-found    If used, return an error if a matching record already
                     exists.  [default: False]
  --force-on-exists  If used, if a match is found on unique fields, other
                     fields will be updated to the provided values. If False,
                     a match causes the request to be a no-op.  [default:
                     False]

Global Options:
  --use-token                     Turn on Tower's token-based authentication.
                                  No longer supported in Tower 3.3 and above.
  --certificate TEXT              Path to a custom certificate file that will
                                  be used throughout the command. Overwritten
                                  by --insecure flag if set.
  --insecure                      Turn off insecure connection warnings. Set
                                  config verify_ssl to make this permanent.
  --description-on                Show description in human-formatted output.
  -v, --verbose                   Show information about requests being made.
  -f, --format [human|json|yaml|id]


$ tower-cli user create --username isweluiz --first-name Luiz --last-name SRE --password "G00GL3" --email sre@gmail.com

Resource changed.
== ======== ============= ========== ========= ============ ================= 
id username     email     first_name last_name is_superuser is_system_auditor 
== ======== ============= ========== ========= ============ ================= 
 3 isweluiz sre@gmail.com Luiz       SRE              false             false
== ======== ============= ========== ========= ============ =================


```

After have created a user, we can go ahead and create a organization, then a team, after all we can link a user in a team:

```bash

>> Creating a organization 

$ tower-cli organization create --help
Usage: tower-cli organization create [OPTIONS]

  Create an organization.

  Fields in the resource's --identity tuple are used for a lookup; if a
  match is found, then no-op (unless --force-on-exists is set) but do not
  fail (unless --fail-on-found is set).

Field Options:
  -n, --name TEXT           [REQUIRED] The name field.
  -d, --description TEXT    The description field.
  --custom-virtualenv TEXT  The custom_virtualenv field.

Local Options:
  --fail-on-found    If used, return an error if a matching record already
                     exists.  [default: False]
  --force-on-exists  If used, if a match is found on unique fields, other
                     fields will be updated to the provided values. If False,
                     a match causes the request to be a no-op.  [default:
                     False]

Global Options:
  --use-token                     Turn on Tower's token-based authentication.
                                  No longer supported in Tower 3.3 and above.
  --certificate TEXT              Path to a custom certificate file that will
                                  be used throughout the command. Overwritten
                                  by --insecure flag if set.
  --insecure                      Turn off insecure connection warnings. Set
                                  config verify_ssl to make this permanent.
  --description-on                Show description in human-formatted output.
  -v, --verbose                   Show information about requests being made.
  -f, --format [human|json|yaml|id]
                                  Output format. The "human" format is
                                  intended for humans reading output on the
                                  CLI; the "json" and "yaml" formats provide
                                  more data, and "id" echos the object id
                                  only.
  -p, --tower-password TEXT       Password to use to authenticate to Ansible
                                  Tower. This will take precedence over a
                                  password provided to `tower config`, if any.
                                  If value is ASK you will be prompted for the
                                  password
  -u, --tower-username TEXT       Username to use to authenticate to Ansible
                                  Tower. This will take precedence over a
                                  username provided to `tower config`, if any.
  -t, --tower-oauth-token TEXT    OAuth2 token to use to authenticate to
                                  Ansible Tower. This will take precedence
                                  over a token provided to `tower config`, if
                                  any.
  -h, --tower-host TEXT           The location of the Ansible Tower host.
                                  HTTPS is assumed as the protocol unless
                                  "http://" is explicitly provided. This will
                                  take precedence over a host provided to
                                  `tower config`, if any.

Other Options:
  --help  Show this message and exit.


$ tower-cli organization  create --name dev --description "Dev team" 
Resource changed.
== ==== 
id name 
== ==== 
 3 dev
== ==== 

$ tower-cli organization list
== ======= 
id  name   
== ======= 
 2 3TB
 1 Default
 3 dev
== ======= 


>> Creating a team

$ tower-cli  team create
Usage: tower-cli team create [OPTIONS]

  Create a team.

  Fields in the resource's --identity tuple are used for a lookup; if a
  match is found, then no-op (unless --force-on-exists is set) but do not
  fail (unless --fail-on-found is set).

Field Options:
  -n, --name TEXT              [REQUIRED] The name field.
  --organization ORGANIZATION  [REQUIRED] The organization field.
  -d, --description TEXT       The description field.

Local Options:
  --fail-on-found    If used, return an error if a matching record already
                     exists.  [default: False]
  --force-on-exists  If used, if a match is found on unique fields, other
                     fields will be updated to the provided values. If False,
                     a match causes the request to be a no-op.  [default:
                     False]

Global Options:
  --use-token                     Turn on Tower's token-based authentication.
                                  No longer supported in Tower 3.3 and above.
  --certificate TEXT              Path to a custom certificate file that will
                                  be used throughout the command. Overwritten
                                  by --insecure flag if set.
  --insecure                      Turn off insecure connection warnings. Set
                                  config verify_ssl to make this permanent.
  --description-on                Show description in human-formatted output.
  -v, --verbose                   Show information about requests being made.
  -f, --format [human|json|yaml|id]
                                  Output format. The "human" format is
                                  intended for humans reading output on the
                                  CLI; the "json" and "yaml" formats provide
                                  more data, and "id" echos the object id
                                  only.
  -p, --tower-password TEXT       Password to use to authenticate to Ansible
                                  Tower. This will take precedence over a
                                  password provided to `tower config`, if any.
                                  If value is ASK you will be prompted for the
                                  password
  -u, --tower-username TEXT       Username to use to authenticate to Ansible
                                  Tower. This will take precedence over a
                                  username provided to `tower config`, if any.
  -t, --tower-oauth-token TEXT    OAuth2 token to use to authenticate to
                                  Ansible Tower. This will take precedence
                                  over a token provided to `tower config`, if
                                  any.
  -h, --tower-host TEXT           The location of the Ansible Tower host.
                                  HTTPS is assumed as the protocol unless
                                  "http://" is explicitly provided. This will
                                  take precedence over a host provided to
                                  `tower config`, if any.

Other Options:
  --help  Show this message and exit.


$ tower-cli  team create --name dev_team --organization dev --description "Team members" 
Resource changed.

== ======== ============ 
id   name   organization 
== ======== ============ 
 2 dev_team            3
== ======== ============ 

```

Now we can link our user ```isweluiz``` on ```dev``` team: 

```bash
$ tower-cli team --help
Usage: tower-cli team [OPTIONS] COMMAND [ARGS]...

  Manage teams within Ansible Tower.

Options:
  --help  Show this message and exit.

Commands:
  associate     Associate a user with this team.
  copy          Copy a team.
  create        Create a team.
  delete        Remove the given team.
  disassociate  Disassociate a user with this team.
  get           Return one and exactly one team.
  list          Return a list of teams.
  modify        Modify an already existing team.

tower-cli team associate 
Usage: tower-cli team associate [OPTIONS]

  Associate a user with this team.

Local Options:
  --team TEAM  [required]
  --user USER  [required]
  ..
  ..
  ..

$ tower-cli team associate --team dev_team --user isweluiz
OK. (changed: true)

```

Now go to assign a role to team ```dev_team```

The arguments for all role commands follow the same pattern, although not all arguments are mandatory for all commands. The structure follows the following pattern:

```tower-cli role <action> --type <choice> --user/team <name/pk> --resource <name/pk>```

```bash
$ tower-cli role
Usage: tower-cli role [OPTIONS] COMMAND [ARGS]...

  Add and remove users/teams from roles.

Options:
  --help  Show this message and exit.

Commands:
  copy    Copy a role.
  get     Get information about a role.
  grant   Add a user or a team to a role.
  list    Return a list of roles.
  revoke  Remove a user or a team from a role.

```

Detailed roles from projects, then we will give permission to a project as admin to all members of team dev_team on project name "Debug Variables". 

```bash
$ tower-cli project list

== =============== ======== ================================================ ================== 
id      name       scm_type                     scm_url                          local_path     
== =============== ======== ================================================ ================== 
 6 Demo Project    git      https://github.com/ansible/ansible-tower-samples _6__demo_project
 8 Debug Variables                                                           debug
11 Rest API - TEST                                                           rest_api
18 Legal                                                                     legal
== =============== ======== ================================================ ================== 

$ tower-cli role list --project "Debug Variables"
== ====== =============== ============= 
id  type   resource_name  resource_type 
== ====== =============== ============= 
61 Admin  Debug Variables project
62 Use    Debug Variables project
63 Update Debug Variables project
64 Read   Debug Variables project
== ====== =============== ============= 


$ tower-cli role grant  --type admin --team dev_team --project "Debug Variables"
Resource changed.
== ==== ===== ======= 
id team type  project 
== ==== ===== ======= 
61    2 admin       8
== ==== ===== ======= 

```
## Job managed via CLI 


Good moment, with tower-cli we can manage our jobs, see the output of the execution, launch a job, relaunch and more... 

```bash
 tower-cli job
Usage: tower-cli job [OPTIONS] COMMAND [ARGS]...

  Launch or monitor jobs.

Options:
  --help  Show this message and exit.

Commands:
  cancel    Cancel a currently running job.
  delete    Remove the given job.
  get       Return one and exactly one job.
  launch    Launch a new job based on a job template.
  list      Return a list of jobs.
  monitor   Stream the standard output from a job,...
  relaunch  Relaunch a stopped job.
  status    Print the current job status.
  stdout    Print out the standard out of a unified job...
  wait      Wait for a running job to finish.


 $ tower-cli job list
== ============ =========================== ========== ======= 
id job_template           created             status   elapsed 
== ============ =========================== ========== ======= 
 2            9 2021-11-17T11:28:16.361797Z successful 3.84
 3            9 2021-11-17T11:34:39.109060Z successful 3.589
 6           12 2021-11-23T14:06:17.763752Z successful 2.023
 7           12 2021-11-23T14:06:40.174899Z successful 6.015
19           13 2021-11-23T15:20:53.749328Z successful 1.959
20           14 2021-11-23T15:20:56.230891Z successful 2.127
21           15 2021-11-23T15:20:58.862490Z successful 3.703
22           12 2021-11-23T15:21:03.115524Z successful 4.118
23           17 2021-11-23T15:21:07.855479Z successful 2.638
25           13 2021-11-23T15:24:33.988015Z successful 1.801
26           14 2021-11-23T15:24:36.323327Z successful 1.966
27           15 2021-11-23T15:24:38.794019Z successful 3.315
28           12 2021-11-23T15:24:42.818923Z successful 4.174
29           17 2021-11-23T15:24:47.934389Z successful 2.689
30           17 2021-11-23T15:27:17.180586Z successful 2.224
31           17 2021-11-23T15:27:35.500135Z successful 2.142
33           13 2021-11-23T18:55:01.390872Z successful 11.777
34           14 2021-11-23T18:55:13.690032Z successful 11.792
35           15 2021-11-23T18:55:25.979633Z successful 12.93
36           12 2021-11-23T18:55:39.426993Z successful 3.274
37           17 2021-11-23T18:55:43.230892Z successful 16.862
44           19 2021-12-05T02:00:45.669785Z successful 3.532
45           20 2021-12-05T02:00:49.728300Z successful 0.954
49           19 2021-12-05T02:36:19.749366Z successful 3.51
50           20 2021-12-05T02:36:23.778444Z successful 0.988
== ============ =========================== ========== ======= (Page 1 of 2.)


>>> Checking the stdout of a JOB 

$ tower-cli job stdout 7
Using /etc/ansible/ansible.cfg as config file

PLAY [JIRA TICKET || OPEN TICKET] **********************************************

TASK [Create an issue] *********************************************************
changed: [localhost] => {"changed": true, "meta": {"id": "10110", "key": "MAS-21", "self": "https://isweluiz.atlassian.net/rest/api/2/issue/10110"}}

TASK [Debug issue] *************************************************************
ok: [localhost] => {
    "msg": {
        "changed": true,
        "failed": false,
        "meta": {
            "id": "10110",
            "key": "MAS-21",
            "self": "https://isweluiz.atlassian.net/rest/api/2/issue/10110"
        }
    }
}

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
OK. (changed: false)

```

## Launch a JOB

```bash
tower-cli job_template 
Usage: tower-cli job_template [OPTIONS] COMMAND [ARGS]...

  Manage job templates.

Options:
  --help  Show this message and exit.

Commands:
  associate_credential            Associate a credential with this job...
  associate_ig                    Associate an ig with this job_template.
  associate_label                 Associate a label with this job_template.
  associate_notification_template
                                  Associate a notification template from
                                  this...
  callback                        Contact Tower and request a configuration...
  copy                            Copy a job template.
  create                          Create a job template.
  delete                          Remove the given job template.
  disassociate_credential         Disassociate a credential with this job...
  disassociate_ig                 Disassociate an ig with this job_template.
  disassociate_label              Disassociate a label with this job_template.
  disassociate_notification_template
                                  Disassociate a notification template from...
  get                             Return one and exactly one job template.
  list                            Return a list of job templates.
  modify                          Modify an already existing job template.
  survey                          Get the survey_spec for the job template.

$ tower-cli job_template list
== ================================================ ========= ======= =========================== 
id                       name                       inventory project          playbook           
== ================================================ ========= ======= =========================== 
13 Database -  script                                       3      11 01database.yml
17 Debug - Active legal intercept                           1      11 05debug_variables.yml
 9 Debug ansible variables                                  3       8 debug_vars.yml
12 Debug -  Create new Jira Ticket                          1      11 jira_ticket.yml
== ================================================ ========= ======= =========================== 


$ tower-cli job launch -J 9 

Resource changed.
== ============ =========================== ======= ======= 
id job_template           created           status  elapsed 
== ============ =========================== ======= ======= 
73            9 2021-12-11T07:30:16.714009Z pending 0.0
== ============ =========================== ======= ======= 

$ tower-cli job monitor  73
------Starting Standard Out Stream------
Identity added: /tmp/awx_73_uwybmmcr/artifacts/73/ssh_key_data (root@ansible-master)

PLAY [all] *********************************************************************
------End of Standard Out Stream--------
Resource changed.
== ============ =========================== ========== ======= 
id job_template           created             status   elapsed 
== ============ =========================== ========== ======= 
73            9 2021-12-11T07:30:16.714009Z successful 3.723
== ============ =========================== ========== =======


$ tower-cli job stdout 72
Identity added: /tmp/awx_72_vw75bgtu/artifacts/72/ssh_key_data (root@ansible-master)

PLAY [all] *********************************************************************

TASK [Gathering Facts] *********************************************************
ok: [192.168.99.111]
ok: [192.168.99.114]
ok: [192.168.99.112]
ok: [192.168.99.113]

TASK [debug variable ansible_var] **********************************************
ok: [192.168.99.111] => {
    "msg": "apache"
}
ok: [192.168.99.113] => {
    "msg": "apache"
}
ok: [192.168.99.112] => {
    "msg": "apache"
}
ok: [192.168.99.114] => {
    "msg": "apache"
}

TASK [debug variable package] **************************************************
ok: [192.168.99.111] => {
    "msg": "httpd"
}
ok: [192.168.99.112] => {
    "msg": "httpd"
}
ok: [192.168.99.113] => {
    "msg": "httpd"
}
ok: [192.168.99.114] => {
    "msg": "httpd"
}

PLAY RECAP *********************************************************************
192.168.99.111             : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
192.168.99.112             : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
192.168.99.113             : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
192.168.99.114             : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

OK. (changed: false)

```

Playbook used to debug and test: 


```yaml
---
- hosts: all
  become: false
  tasks:
    - name: debug variable ansible_var
      debug:
        msg: "{{ ansible_var }}"

    - name: debug variable package
      debug:
        msg: "{{ package }}"
```


## Useful Commands 
```bash
tower-cli user list
tower-cli organization list
tower-cli team list
tower-cli job list
tower-cli job list
tower-cli job_template list
tower-cli role list
tower-cli role get  --team 

tower-cli user create
tower-cli team create
tower-cli organization create

tower-cli job launch
tower-cli job monitor
tower-cli job status
tower-cli job stdout
```
