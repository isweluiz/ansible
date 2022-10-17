# Install apache on multiple Debian servers with Ansible role 

- [Role on Github](https://github.com/isweluiz/ansible-role-apache)
- [Role on Galaxy](https://galaxy.ansible.com/geerlingguy/apache)

Requirements for this test: 
- Bastion -> Ansible Server 
- ServerA - Web Server Debian 
- ServerB - Web Server Debian 

Our task are the following:
1. Use the apache role for: 
- Install apache
- Listen on port 80 and 8080
2. Make a index page with "Hello world" on port 8080 
3. Make a index page with "web server IP"  on port 80 

## 1. Search for apache role with author geerlingguy: 
```bash
root@ip-172-31-83-107:/home/admin/ansible# ansible-galaxy search apache --author geerlingguy

Found 15 roles matching your search:

 Name                       Description
 ----                       -----------
 geerlingguy.adminer        Installs Adminer for Database management.
 geerlingguy.apache         Apache 2.x for Linux.
 geerlingguy.apache-php-fpm Apache 2.4+ PHP-FPM support for Linux.
 geerlingguy.certbot        Installs and configures Certbot (for Let's Encrypt).
 geerlingguy.drupal         Deploy or install Drupal on your servers.
 geerlingguy.fluentd        Fluentd for Linux.
 geerlingguy.htpasswd       htpasswd installation and helper role for Linux servers.
 geerlingguy.munin          Munin monitoring server for RedHat/CentOS or Debian/Ubun
 geerlingguy.php            PHP for RedHat/CentOS/Fedora/Debian/Ubuntu.
 geerlingguy.pimpmylog      Pimp my Log installation for Linux
 geerlingguy.solr           Apache Solr for Linux.
 geerlingguy.supervisor     Supervisor (process state manager) for Linux.
 geerlingguy.svn            SVN web server for Linux
 geerlingguy.tomcat6        Tomcat 6 for RHEL/CentOS and Debian/Ubuntu.
 geerlingguy.varnish        Varnish for Linux.
```

## 2. Install the role geerlingguy.apache and list your roles directory 
```bash
root@ip-172-31-83-107:/home/admin/ansible# ansible-galaxy install geerlingguy.apache
Starting galaxy role install process
- downloading role 'apache', owned by geerlingguy
- downloading role from https://github.com/geerlingguy/ansible-role-apache/archive/3.1.4.tar.gz
- extracting geerlingguy.apache to /home/admin/ansible/roles/geerlingguy.apache
- geerlingguy.apache (3.1.4) was installed successfully
root@ip-172-31-83-107:/home/admin/ansible# ls -la roles/
total 16
drwxr-xr-x  4 root root 4096 Jul 11 00:57 .
drwxr-xr-x  5 root root 4096 Jul 11 00:07 ..
drwxr-xr-x 10 root root 4096 Jul 11 00:57 geerlingguy.apache
drwxr-xr-x  7 root root 4096 Jul  2 18:40 teampants.haproxy
```

3. Test connection with your webservers
```bash
root@ip-172-31-83-107:/home/admin/ansible# ansible webservers -m ping
servera | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    }, 
    "changed": false, 
    "ping": "pong"
}
serverb | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    }, 
    "changed": false, 
    "ping": "pong"
}
```

## 4. Read the README for adjustment with you need 
```bash
root@ip-172-31-83-107:/home/admin/ansible# more roles/geerlingguy.apache/README.md 
```

## 5. Create the playbook with variables includes or create the variable file vars/main.yml into the roles
```yaml

---
- name: Apache role 
  hosts: webservers 
  become: true
  vars: 
    apache_listen_ip: "*"
    apache_listen_port: 8080 
    apache_create_vhosts: true
    apache_vhosts_filename: "vhosts.conf"
    apache_vhosts_template: "vhosts.conf.j2"
    apache_vhosts:
      - servername: "webserver.dev"
        documentroot: "/mnt/data/html/"
    apache_global_vhost_settings: |
        DirectoryIndex index.html
    apache_allow_override: "All"
    apache_options: "-Indexes +FollowSymLinks"
    apache_state: started
    vhost_page: "/mnt/data/htdocs"
    80_index: "/var/www/html/index.html"
  tasks: 
  - include_role:
      name: geerlingguy.apache

  - name: create "{{ vhost_page }}" folder 
    file:
      path: "{{ vhost_page }}"
      state: directory
      mode: 0764  
      
  - name: create index file port 8080 
    copy:
      content: "Hello wolrd"
      dest: "{{ vhost_page }}/index.html"

  - name: create index file port 80
    copy:
      content: "{{ ansible_default_ipv4.address }}  has been customized with ansible"
      dest: "{{ 80_index }}"
...
```

## 6. Run you playbook 
```bash
root@ip-172-31-83-107:/home/admin/ansible# ansible-playbook playbooks/webserver.yml 
PLAY [Apache role] *****************************************************************

TASK [Gathering Facts] *************************************************************
ok: [serverb]
ok: [servera]

TASK [include_role : geerlingguy.apache] *******************************************

TASK [geerlingguy.apache : Include OS-specific variables.] *************************
ok: [servera]
ok: [serverb]

TASK [geerlingguy.apache : Include variables for Amazon Linux.] ********************
skipping: [servera]
skipping: [serverb]

TASK [geerlingguy.apache : Define apache_packages.] ********************************
ok: [servera]
ok: [serverb]

TASK [geerlingguy.apache : include_tasks] ******************************************
included: /home/admin/ansible/roles/geerlingguy.apache/tasks/setup-Debian.yml for servera, serverb

TASK [geerlingguy.apache : Update apt cache.] **************************************
changed: [serverb]
changed: [servera]

TASK [geerlingguy.apache : Ensure Apache is installed on Debian.] ******************
changed: [serverb]
changed: [servera]

TASK [geerlingguy.apache : Get installed version of Apache.] ***********************
ok: [servera]
ok: [serverb]

TASK [geerlingguy.apache : Create apache_version variable.] ************************
ok: [servera]
ok: [serverb]

TASK [geerlingguy.apache : Include Apache 2.2 variables.] **************************
skipping: [servera]
skipping: [serverb]

TASK [geerlingguy.apache : Include Apache 2.4 variables.] **************************
ok: [servera]
ok: [serverb]

TASK [geerlingguy.apache : Configure Apache.] **************************************
included: /home/admin/ansible/roles/geerlingguy.apache/tasks/configure-Debian.yml for servera, serverb

TASK [geerlingguy.apache : Configure Apache.] **************************************
changed: [serverb] => (item={u'regexp': u'^Listen ', u'line': u'Listen 8080'})
changed: [servera] => (item={u'regexp': u'^Listen ', u'line': u'Listen 8080'})

TASK [geerlingguy.apache : Enable Apache mods.] ************************************
changed: [serverb] => (item=rewrite.load)
changed: [servera] => (item=rewrite.load)
changed: [servera] => (item=ssl.load)
changed: [serverb] => (item=ssl.load)

TASK [geerlingguy.apache : Disable Apache mods.] ***********************************

TASK [geerlingguy.apache : Check whether certificates defined in vhosts exist.] ****

TASK [geerlingguy.apache : Add apache vhosts configuration.] ***********************
changed: [serverb]
changed: [servera]

TASK [geerlingguy.apache : Add vhost symlink in sites-enabled.] ********************
changed: [servera]
changed: [serverb]

TASK [geerlingguy.apache : Remove default vhost in sites-enabled.] *****************
skipping: [servera]
skipping: [serverb]

TASK [geerlingguy.apache : Ensure Apache has selected state and enabled on boot.] ***
ok: [servera]
ok: [serverb]

TASK [create "/mnt/data/htdocs"] ***************************************************
changed: [servera]
changed: [serverb]

TASK [create index file port 8080] *************************************************
changed: [servera]
changed: [serverb]

TASK [create index file port 80] ***************************************************
changed: [servera]
changed: [serverb]

RUNNING HANDLER [geerlingguy.apache : restart apache] ******************************
changed: [serverb]
changed: [servera]

PLAY RECAP *************************************************************************
servera                    : ok=19   changed=10   unreachable=0    failed=0    skipped=5    rescued=0    ignored=0   
serverb                    : ok=19   changed=10   unreachable=0    failed=0    skipped=5    rescued=0    ignored=0   

```

Then, check your apache pages: 

Page with port 80 
![](https://i.ibb.co/wczb8r6/Screen-Shot-2021-07-11-at-00-07-52.png)

Page with port 8080 
![](https://i.ibb.co/sP7KQPf/8080.png)
