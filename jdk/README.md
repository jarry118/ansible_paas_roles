JDK
=========

JDK is a development environment for building applications and components using the Java programming language.

Requirements
------------

This role requires Ansible 1.9 or higher.

Role Variables
--------------

| Name                 | Default |Description              |
|:---------------------|:--------|:------------------------|
| java_version         | 7       | Main version of JDK     |
| java_subversion      | 80      | sub Version of JDK      |
| java_install_path    | /test   | JDK install path        |

Dependencies
------------

None

Example Playbook
----------------

Install JDK7:
```yaml
- name: configure the paas jdk
  hosts: all
  gather_facts: no
  vars:
    - java_subversion: 75  
      java_version: 7
      java_install_path: /home/test
  roles:
    - sitech.jdk
```

License
-------

BSD

Author Information
------------------

Jarry Wong.
