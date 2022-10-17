## RUNDECK WITH ACTIVE DIRECTORY AUTHENTICATION

- [Official documentation](https://docs.rundeck.com/docs/administration/security/authentication.html#ldap)

Create A bind User and the Security Groups in Active Directory
Before integrating Rundeck with Active Directory, we need to create a bind User and two security groups called `rundeck_administrators` and `rundeck_users`. Finally, add the appropriate users into those groups before proceeding.

### Create jaas-activedirectory.conf file
Create a jaas-activedirectory.conf file as below:

```bash
# vi /etc/rundeck/jaas-activedirectory.conf
  activedirectory {
    com.dtolabs.rundeck.jetty.jaas.JettyCachingLdapLoginModule required
    debug="true"
    contextFactory="com.sun.jndi.ldap.LdapCtxFactory"
    providerUrl="ldap://IP_DOMAIN_CONTROLER:389"
    bindDn="CN=YOUR_BIND_USER,OU=Rundeck,OU=Application,DC=COMPANY,DC=LOCAL"
    bindPassword="XXXXXXXXXXXXXXX"
    authenticationMethod="simple"
    forceBindingLogin="true"
    userBaseDn="DC=YALLALABS,DC=LOCAL"
    userRdnAttribute="sAMAccountName"
    userIdAttribute="sAMAccountName"
    userPasswordAttribute="unicodePwd"
    userObjectClass="user"
    roleBaseDn="OU=Rundeck,OU=Application,DC=COMPANY,DC=LOCAL"
    roleNameAttribute="cn"
    roleMemberAttribute="member"
    roleObjectClass="group"
    cacheDurationMillis="300000"
    reportStatistics="true";
};
```

- providerUrl: IP Address Or FQDN of your Domain Controller
- bindDn: LDAP Bind User Distinguished Name
- bindPassword: Password of the LDAP Bind User
- userBaseDn: Distinguished name to use as a search base for finding users.
- roleBaseDn: OU where the rundeck security groups are.

- Finally, change the ownership of the file and set up the correct permission:

```bash
# chown rundeck:rundeck /etc/rundeck/jaas-activedirectory.conf
# chmod 640 /etc/rundeck/jaas-activedirectory.conf
```

### Edit /etc/rundeck/profile
We need add the path to the `jaas-activedirectory.conf` file and setup the Dloginmodule.name value to activedirectory. Modify the `/etc/rundeck/profile` as below:

```bash
# vi /etc/rundeck/profile
############## Before #####################

RDECK_JVM="-Djava.security.auth.login.config=$JAAS_CONF \
           -Dloginmodule.name=$LOGIN_MODULE \

############# After #######################


RDECK_JVM="-Djava.security.auth.login.config=/etc/rundeck/jaas-activedirectory.conf \
           -Dloginmodule.name=activedirectory \
```

### Create the /etc/rundeck/rundeck_administrators.aclpolicy File
Let’s create an ACL policy file called `rundeck_administrators.aclpolicy` for the `rundeck_administrators` AD Security group that will have Admin Access in Rundeck

```bash
# vi /etc/rundeck/rundeck_administrators.aclpolicy
description: Administrators, all access.
context:
  project: '.*' # all projects
for:
  resource:
    - equals:
        kind: job
      allow: [create] # allow create jobs
    - equals:
        kind: node
      allow: [read,create,update,refresh] # allow refresh node sources
    - equals:
        kind: event
      allow: [read,create] # allow read/create events
  adhoc:
    - allow: [read,run,runAs,kill,killAs] # allow running/killing adhoc jobs
  job:
    - allow: [create,read,update,delete,run,runAs,kill,killAs,toggle_schedule] # allow create/read/write/delete/run/kill of all jobs
  node:
    - allow: [read,run] # allow read/run for nodes
by:
  group: rundeck_administrators
 
---
 
description: Administrators, all access.
context:
  application: 'rundeck'
for:
  resource:
    - equals:
        kind: project
      allow: [create] # allow create of projects
    - equals:
        kind: system
      allow: [read,enable_executions,disable_executions,admin] # allow read of system info, enable/disable all executions
    - equals:
        kind: system_acl
      allow: [read,create,update,delete,admin] # allow modifying system ACL files
    - equals:
        kind: user
      allow: [admin] # allow modify user profiles
  project:
    - match:
        name: '.*'
      allow: [read,import,export,configure,delete,admin] # allow full access of all projects or use 'admin'
  project_acl:
    - match:
        name: '.*'
      allow: [read,create,update,delete,admin] # allow modifying project-specific ACL files
  storage:
    - allow: [read,create,update,delete] # allow access for /ssh-key/* storage content
 
by:
  group: rundeck_administrators
```

Change the ownership and set the correct permission of the `rundeck_administrators.aclpolicy` as below:

```bash
chown rundeck:rundeck /etc/rundeck/rundeck_administrators.aclpolicy
chmod 640 /etc/rundeck/rundeck_administrators.aclpolicy
```

### Create the /etc/rundeck/rundeck_users.aclpolicy File
We need to create an ACL policy file called `rundeck_users.aclpolicy` for the `rundeck_users` AD Security group that will have just read only Access in Rundeck

```bash
# vi /etc/rundeck/rundeck_users.aclpolicy
description: Standard Users project level access control.
context:
  project: '.*' # all projects
for:
  resource:
    - equals:
        kind: job
      allow: [read] # allow read jobs
    - equals:
        kind: node
      allow: [read] # allow refresh node sources
    - equals:
        kind: event
      allow: [read] # allow read/read events
  adhoc:
    - allow: [read] # allow read adhoc jobs
  job:
    - allow: [read] # allow read of all jobs
  node:
    - allow: [read] # allow read for nodes
by:
  group: rundeck_users
 
---
 
description: A
context:
  application: 'rundeck'
for:
  resource:
    - equals:
        kind: project
      allow: [read] # allow read of projects
    - equals:
        kind: system
      allow: [read] # allow read executions
    - equals:
        kind: system_acl
      allow: [read] # allow reading system ACL files
  project:
    - match:
        name: '.*'
      allow: [read] # allow read access of all projects or use 'admin'
  project_acl:
    - match:
        name: '.*'
      allow: [read] # allow reading project-specific ACL files
  storage:
    - allow: [read] # allow read access for /ssh-key/* storage content
 
by:
  group: rundeck_users
```

Change the ownership and set the correct permission of the `rundeck_users.aclpolicy` as below:

```bash
chown rundeck:rundeck /etc/rundeck/rundeck_users.aclpolicy
chmod 640 /etc/rundeck/rundeck_users.aclpolicy
```

### Edit the /var/lib/rundeck/exp/webapp/WEB-INF/web.xml file

Create the new roles by editing the file /var/lib/rundeck/exp/webapp/WEB-INF/web.xml

```bash
# vi /var/lib/rundeck/exp/webapp/WEB-INF/web.xml
<security-role>
    <role-name>rundeck_administrators</role-name>
</security-role>
<security-role>
     <role-name>rundeck_users</role-name>
</security-role>
```

### Restart Rundeck
Finally restart the Rundeck daemon:

```bash
# systemctl restart rundeckd
```


