Instalação do Wildfly 21.0.1 com JAVA 1.8
=========

Os Playboks são usados na maioria das vezes para construir interações complexas que requerem, por exemplo, provisionamento de software em máquinas remotas. Neste exemplo, veremos como
combinar nosso Playbook que irá instalar o JDK o unzip e o Wildfly, o servidor de aplicativos por sua vez será configurado no modo standalone. 

Requirements
------------
Certifique-se que o seu host(target) possui acesso a internet, python 2.6 ou superior instalado para suportar os módulos do ansible e também algum repositório que possui o JAVA para download. 


Role Variables
--------------

https_uri: https://download.jboss.org/wildfly/21.0.1.Final/wildfly-21.0.1.Final.zip
wildfly_user: wildfly


O endereço das interfaces pública e de gerenciamento serão alteradas pela variável do IPV4 padrão do host destino, "{{ ansible_default_ipv4.address }}". 

```xml
 <interfaces>
        <interface name="management">
            <inet-address value="${jboss.bind.address.management:192.168.0.86}"/>
        </interface>
        <interface name="public">
            <inet-address value="${jboss.bind.address:192.168.0.86}"/>
```

Example Playbook
----------------

```yml
---
- name: Instalacao do Wildfly 21.0.1
- hosts: webapp
  become: true
  roles:
    - isweluiz.wildfly-install
...
```

License
-------

BSD

Author Information
------------------

Autor: Luiz Eduardo

Blog: blog.isweluiz.com.br

Linkedin: https://www.linkedin.com/in/isweluiz/
