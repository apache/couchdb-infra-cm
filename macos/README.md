# Creating a macOS CI node

## Goals

- [x] given a macOS host, turn it into a fully functional CI node
  - eventually intel & arm, arm only for now
- [x] be able to run CouchDB CI jobs against latest homebrew dependencies
- eventually, cover erlang@23, erlang@24, erlang@25 and matching elixirs
  - but start with erlang@25 (latest) for now

## Requirements

`~/.ansible/couchdb-ansible-vault` set up. Talk to the PMC if you don’t have this.

## Dependencies:

- Ansible (`brew install ansible`)

## Usage

```shell
cd playbook
ansible-playbook macos.yml
```
