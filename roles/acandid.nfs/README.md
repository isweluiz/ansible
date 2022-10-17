# Ansible Role: nfs
=========

A simple Ansible role for installing and configuring NFS Server for RHEL/CentOS 7.

- Install the necessary packages;
- Create configuration file;
- Create directory owner group;
- Create shared directory;
- Create mount point;


Requirements
------------

- The SELinux and firewall settings are not considered to be a concern of this role.

Role Variables
--------------


Variables below are required

| Variable                                     | Default                       | Comments                                     
| :---                                         | :---                          | :---       
|                                              |                               |
| `nfs_share`                                  |                               | Inform shared directory 
|                                              |                               |
| `nfs_group_name`                             |                               | Inform directory owner group
|                                              |                               |
| `nfs_mount_point`                            |                               | Inform mount point
|                                              |                               |


Dependencies
------------

You need to install python-apt package on debian 10 


Example Playbook
----------------

---
- hosts: nfs_server, client

  roles:

    - /path/nfs

...

Example inventory file
----------------------
[nfs_server]

192.168.0.6

[client]

192.168.0.9

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section.


Author Information
------------------
LinkedIn: https://br.linkedin.com/in/almircandido
