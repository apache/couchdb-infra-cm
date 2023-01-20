# Creating a FreeBSD CI node

## Goals

- [x] given a FreeBSD host, turn it into a fully functional CI node
  - [x] eventually intel & arm
- [x] be able to run CouchDB CI jobs
- eventually, cover erlang@23, erlang@24, erlang@25 and matching elixirs
  - but start with erlang@25 (latest) for now

## Requirements

`~/.ansible/couchdb-ansible-vault` set up. Talk to the PMC if you don’t have this.

## Dependencies:

- Ansible (`brew/apt/yum install ansible`)

## Usage

```shell
cd playbook
ansible-playbook freebsd.yml
```
