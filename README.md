# Welcome to my place!

-------
@Author: Luiz Eduardo 



#### Contact 
> [Linkedin](https://www.linkedin.com/in/isweluiz/) 

`'' I think 99 times and I find nothing; Well of thinking, diving into silence, and the truth revealed to me (...) ''`

## Playbook execution
`$ansible-playbook -i hosts  set-ssh.yaml --ask-pass`

# [Ansible](https://www.redhat.com/pt-br/technologies/management/ansible)
My anotations about ansible

*O Red Hat&reg; Ansible&reg; Automation Platform serve como uma base para criar e operar a automação por toda a empresa. A plataforma inclui todas as ferramentas necessárias para implementar a automação em toda a empresa.*

[![CHEAT](https://intellipaat.com/blog/wp-content/uploads/2019/03/Ansible-cheat-sheet-1.jpg)](https://www.digitalocean.com/community/cheatsheets/how-to-use-ansible-cheat-sheet-guide)

## Ansible Terms

- [Ansible History](https://opensource.com/article/21/2/ansible-origin-story)


Before we get into the important Ansible commands, first, let's understand its basic terminology.

- Server: An entity that provides service for our Ansible

- Machine: A physical machine, a VM, or a container Target machine: An end machine to be configured by Ansible

- Task: An action

- Playbook: A location where YAML files are written and executed YAML

As mentioned earlier, YAML (Yet Another Markup Language) is a human-readable programming language. YAML syntax is used to express the Ansible playbooks.

Here are some basic concepts of YAML.

Key/Value pair:
Dictionary is represented in key/value pairs.

Example:


```yml
james:
name: james john
rollNo: 34
div: B
sex: male
```

Representing lists:
Each element in a list has to be written in a new line with '-' as a prefix.

```yml
Example:
countries:
- America
- China
- Canada
- Iceland
```

Lists inside a dictionary:
We can have lists inside a dictionary.

Example

```yml
james:
name: james john
rollNo: 34
div: B
sex: male
likes:
- maths
- physics
- english
```


### Roles 

- [ansible-package-debian-manage](https://github.com/isweluiz/ansible-package-debian-manage)
