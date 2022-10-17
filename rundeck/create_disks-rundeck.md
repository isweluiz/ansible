
Criar um JOB no rundeck com os dois workflows abaixo: 

1 - Ansible Playbook Inline Workflow Node Step

2 - Shell script 

```yaml 
---
- name: Adicionando discos
  hosts: all
  become: true
  vars:
    disk1: /dev/mapper/mpaths
    disk2: /dev/mapper/mpatht
    disk3: /dev/mapper/mpathu
    disk4: /dev/mapper/mpathv
    disk5: /dev/mapper/mpathw
  tasks:
    - name: Create part
      parted:
        device: "{{ item }}"
        number: 1
        part_end: "100%"
        state: present
      with_items:
        - "{{ disk1 }}"
        - "{{ disk2 }}"
        - "{{ disk3 }}"
        - "{{ disk4 }}"
        - "{{ disk5 }}"
```

```bash
#!/bin/bash

sudo rescan-scsi-bus.sh
sudo multipath -r

sudo chmod 660 /dev/mapper/mpathn1
sudo chmod 660 /dev/mapper/mpathp1
sudo chmod 660 /dev/mapper/mpathq1
sudo chmod 660 /dev/mapper/mpatho1
sudo chmod 660 /dev/mapper/mpathr1
sudo chmod 660 /dev/mapper/mpathm1

sudo chown grid:asmadmin /dev/mapper/mpathn1
sudo chown grid:asmadmin /dev/mapper/mpathp1
sudo chown grid:asmadmin /dev/mapper/mpathq1
sudo chown grid:asmadmin /dev/mapper/mpatho1
sudo chown grid:asmadmin /dev/mapper/mpathr1
sudo chown grid:asmadmin /dev/mapper/mpathm
```
