CouchDB Infrastructure Config Management
===

This repository contains Ansible scripts for managing our VM testing
infrastructure.

Setup
---

    $ virtualenv venv
    $ source venv/bin/activate
    $ pip install -r requirements.txt

Provisioning VMs
---

The basic steps to provisioning a new Jenkins agent node are:

1. Provision new VM using https://cloud.ibm.com
2. Run `./tools/gen-config`
3. Create the agent in Jenkins (copying an existing node is easiest)
4. Encrypt the Jenkins secret using `ansible-vault`
5. Store the new secret in the appropriate `host_vars/hostname.yml` file
6. Run `ansible-playbook ci_agents.yml`

Node names should follow this pattern:

```
couchdb-worker-$arch-$osname-$zone-$node_id
```

I.e.:

```
couchdb-worker-x86-64-debian-dal-1-01
```

Bastion VMs
---

There should be a single bastion VM setup for each subnet. We just use the
cheapest cx2-2x4 instance for these nodes so that we can jump to the other
hosts.

Provisioning a bastion VM is much the same as for a ci_agent though should
happen much more rarely. Currently the assumption is that each subnet has
exactly one bastion. The `./tools/gen-config` script will complain if this
assumption is violated so it should be obvious if we get this wrong. It will
also complain if we have a subnet that is missing a bastion box.

The steps for provisioning a new bastion box are:

1. Provision the VM using https://cloud.ibm.com
2. Run `./tools/gen-config`
3. Run `ansible-playbook bastions.yml`

Bastion names should follow this pattern:

```
couchdb-bastion-$arch-$osname-$zone-$node_id
```

I.e.,

```
couchdb-bastion-x86-64-debian-dal-1-01
```


Running `./tools/gen-config`
---

Create a `~/.couchdb-infra-cm.cfg` file that contains the following options:

    [ibmcloud]
    api_key = <REDACTED>

The `tools/gen-config` script can then be used to generate our `production`
inventory and `ssh.cfg` configuration:

    $ ./tools/gen-config

This script requires access to the `https://cloud.ibm.com` account that hosts
the VMs so not everyone will be able to run this script. However this is only
important when provisioning new nodes. Modifying ansible scripts and apply
changes to existing nodes can be done by any CouchDB PMC member that's been
added to the CI nodes via this repository.

Running Ansible
---

    $ ansible-playbook bastions.yml
    $ ansible-playbook ci_agents.yml


Useful Commands:
---

If you want to ssh directly to a node, you can do:

```bash
$ ssh -F ssh.cfg $hostname
```

I.e.,

```bash
$ ssh -F ssh.cfg couchdb-worker-x86-64-debian-dal-1-01
```
