CouchDB Infrastructure Config Management
===

This repository contains Ansible scripts for managing our VM testing infrastructure.

Setup
---

    $ virtualenv venv
    $ source venv/bin/activate
    $ pip install -r requirements.txt

Provisioning VMs
---

Our main workhorse is the cx2-4x8 instance type. There are also a few
ppc64le nodes for doing full builds as well. Whoever provisions a VM should
make sure to generate a new inventory as well as perform the first Ansible
run against the new node so that other CouchDB infra members will have access.


Bastion VMs
---

There should be a single bastion VM setup for each subnet. We just use the
cheapest cx2-2x4 instance for these nodes so that we can jump to the other
hosts.

If the bastion changes public IP addresses we have to update `group_vars/ci_agents.yml`
and set the `ansible_ssh_common_args` to use the new public IP for contacting
servers. We should also update `ssh.cfg` in this repository to make it easier
for contacting servers manually.


Generating Inventory Listings
---

Create a `~/.couchdb-infra-cm.cfg` file that contains the following options:

    [ibmcloud]
    api_key = <REDACTED>

The `tools/gen-inventory` script can then be used to generate our `production`
inventory file:

    $ ./tools/gen-inventory > production


Configuring Jenkins
---

Once a CI worker has been provisioned we must also configure Jenkins to have
the JAR url and secret ready. The easiest approach here is to just copy the
existing configuration from one of the existing nodes. When viewing the
conifguration page we then dump the secret value into an encrypted vault
file in the `host_vars` directory.


Running Ansible
---

    $ ansible-playbook -i production ci_agents.yml


Useful Commands:
---

If you want to ssh directly to a node, you can do:

```bash
$ ssh -F ssh.cfg $private_ip
```
