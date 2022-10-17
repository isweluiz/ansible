CREEATE NEW USERS
=========

This role shoud be used for create new users.

Requirements
------------

None.

Role Variables
--------------

This variables is defined on vars/main.yml, for view the file enter:

```bash
$ ansible-vault view roles/create-user.le/vars/main.yml --vault-password-file=secret
```

For edit file, include and or remove users and passwords, enter:

```bash
$ ansible-vault edit roles/create-user.le/vars/main.yml --vault-password-file=secret
```

```yaml
users:
    - name: luiz.pereira
      comment: "Linux/Aplicacao"
      pw: "%.LINUX@RedHat.$"
      shell: /bin/bash
      group: wheel
      job: App
#      groups: wheel,linux

    - name: joao.delax
      comment: "Dev"
      pw: "$%CHIbata%$."
      shell: /bin/bash
      group: wheel
      job: Dev

    - name: trump.won
      comment: "President"
      pw: "$%Bbabaa%$."
      shell: /bin/false
      group: wheel
      job:
```

Dependencies
------------

None.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

### The files file is encrypted with the vault

```bash
[sandy@ip-172-31-36-157 ansible]$ cat roles/create-user.le/vars/main.yml 
$ANSIBLE_VAULT;1.1;AES256
33653633643438346239653332303434363764376135393335303438326562656161656464623463
3231303637643939643739383639653633303664616561620a613833626535336666633766373865
31363538386236346237363039656432666263383832373436306636363331646162366333633561
```

$ ansible-playbook users.yml --vault-password-file=secret


```yaml
---
- name: Create new users 
  hosts: all
  become: true
  serial: 20
  roles:
    - create-user.le
...
```


Or, you can select specific groups for create the users

```yaml
---
- name: Create new users
  hosts: all
  become: true
  serial: 20
  tasks:
    - include_role:
        name: create-user.le
      when: inventory_hostname['dev'] and item.job == "dev"
...
```

Or, you can select multiple groups

```yaml
---
- name: Create new users
  hosts: all
  become: true
  serial: 20
  tasks:
    - include_role:
        name: create-user.le
      when: 
 	- inventory_hostname in groups['dev'] or inventory_hostname in groups['webservers']
...
```

```bash
[luiz.eduardo@ip-172-31-36-157 ansible]$ ansible-playbook users.yml --vault-password-file=secret

PLAY [Create new users] ********************************************************************************

TASK [Gathering Facts] *********************************************************************************
ok: [node4]
ok: [node1]
ok: [node5]
ok: [node2]
ok: [node3]

TASK [create-user.le : user] ***************************************************************************
changed: [node4] => (item={'name': 'luiz.pereira', 'comment': 'Linux/Aplicacao', 'pw': '%.LINUX@RedHat.$', 'shell': '/bin/bash', 'group': 'wheel', 'job': 'App'})
changed: [node1] => (item={'name': 'luiz.pereira', 'comment': 'Linux/Aplicacao', 'pw': '%.LINUX@RedHat.$', 'shell': '/bin/bash', 'group': 'wheel', 'job': 'App'})
changed: [node5] => (item={'name': 'luiz.pereira', 'comment': 'Linux/Aplicacao', 'pw': '%.LINUX@RedHat.$', 'shell': '/bin/bash', 'group': 'wheel', 'job': 'App'})
changed: [node3] => (item={'name': 'luiz.pereira', 'comment': 'Linux/Aplicacao', 'pw': '%.LINUX@RedHat.$', 'shell': '/bin/bash', 'group': 'wheel', 'job': 'App'})
changed: [node2] => (item={'name': 'luiz.pereira', 'comment': 'Linux/Aplicacao', 'pw': '%.LINUX@RedHat.$', 'shell': '/bin/bash', 'group': 'wheel', 'job': 'App'})
changed: [node4] => (item={'name': 'joao.delax', 'comment': 'Dev', 'pw': '$%CHIbata%$.', 'shell': '/bin/bash', 'group': 'wheel', 'job': 'Dev'})
changed: [node1] => (item={'name': 'joao.delax', 'comment': 'Dev', 'pw': '$%CHIbata%$.', 'shell': '/bin/bash', 'group': 'wheel', 'job': 'Dev'})
changed: [node5] => (item={'name': 'joao.delax', 'comment': 'Dev', 'pw': '$%CHIbata%$.', 'shell': '/bin/bash', 'group': 'wheel', 'job': 'Dev'})
changed: [node3] => (item={'name': 'joao.delax', 'comment': 'Dev', 'pw': '$%CHIbata%$.', 'shell': '/bin/bash', 'group': 'wheel', 'job': 'Dev'})
changed: [node4] => (item={'name': 'trump.won', 'comment': 'President', 'pw': '$%Bbabaa%$.', 'shell': '/bin/false', 'group': 'wheel', 'job': None})
changed: [node1] => (item={'name': 'trump.won', 'comment': 'President', 'pw': '$%Bbabaa%$.', 'shell': '/bin/false', 'group': 'wheel', 'job': None})
changed: [node2] => (item={'name': 'joao.delax', 'comment': 'Dev', 'pw': '$%CHIbata%$.', 'shell': '/bin/bash', 'group': 'wheel', 'job': 'Dev'})
changed: [node5] => (item={'name': 'trump.won', 'comment': 'President', 'pw': '$%Bbabaa%$.', 'shell': '/bin/false', 'group': 'wheel', 'job': None})
changed: [node3] => (item={'name': 'trump.won', 'comment': 'President', 'pw': '$%Bbabaa%$.', 'shell': '/bin/false', 'group': 'wheel', 'job': None})
changed: [node2] => (item={'name': 'trump.won', 'comment': 'President', 'pw': '$%Bbabaa%$.', 'shell': '/bin/false', 'group': 'wheel', 'job': None})

PLAY RECAP *********************************************************************************************
node1                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node2                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node3                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node4                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node5                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```



License
-------

BSD

Author Information
------------------

Luiz Eduardo. 


[Github](https://github.com/isweluiz)


[Blog](http://blog.isweluiz.com.br)

