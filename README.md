Ansible Role: prezto
=========
[![CI](https://github.com/brianhartsock/ansible-role-prezto/actions/workflows/ci.yml/badge.svg)](https://github.com/brianhartsock/ansible-role-prezto/actions/workflows/ci.yml)

Role to install [Prezto](https://github.com/sorin-ionescu/prezto) for users on Linux or OSX systems.

Requirements
------------

Role has been tested on Ubuntu 20.04, 22.04, 24.04 and Mac OSX Sonoma. Although any operating system that can run ZSH should work.

Git is required to checkout the Prezto source.

The role should be run as the user you wish to install Prezto for.

Role Variables
--------------

The following variables are defined in `defaults/main.yml` and can be used to further configure Prezto.

```yaml
# Git URL hosting the Prezto source you wish to install
prezto_repo: https://github.com/brianhartsock/prezto.git

# Location to install Prezto
prezto_repo_destination: ~/.zprezto

# Whether or not to accept the host key for the Git server
prezto_repo_accept_host_key: false

# Git branch/tag/commit to checkout
prezto_repo_version: HEAD
```

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - role: brianhartsock.prezto
         - role: brianhartsock.prezto
           become: yes
           become_user: other_user

License
-------

MIT

Author Information
------------------

Created with love by [Brian Hartsock](http://blog.brianhartsock.com).
